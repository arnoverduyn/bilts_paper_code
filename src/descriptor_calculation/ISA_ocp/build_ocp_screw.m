function [opti, var, param] = build_ocp_screw(L,N,rms_rot,rms_pos)

            % Setting parameters of optimization problem
            max_iters = 100;    % maximum number of iterations

            %% Define a symbolic function necessary to integrate invariants in a correct geometric way
            load_casadi_library()
            import casadi.*
        
            % System states
            T_isa  = SX.sym('T_isa',3,4); % instantaneous screw axis frame
            T_obj = SX.sym('T_obj',3,4); % object frame
            x = [T_isa(:) ; T_obj(:)];

            % System controls (invariants)
            u = SX.sym('i',6);
            h = SX.sym('h');

            % Define a geometric integrator for SAI, (meaning rigid-body motion is perfectly integrated assuming constant invariants)
            [T_isa_plus1,T_obj_plus1] = integrator_screw_invariants_to_pose(T_isa,T_obj,u,h);
            out_plus1 = [T_isa_plus1(:) ; T_obj_plus1(:)];
            geom_integr = Function('phi', {x,u,h} , {out_plus1});

            %% Create decision variables and parameters for the non-linear optimization problem (NLP)

            opti = casadi.Opti(); % use OptiStack package from Casadi for easy bookkeeping of variables (no cumbersome indexing)

            % Define system states X (unknown object pose + moving frame pose at every time step)
            T_isa = cell(1,N);% instantaneous screw axis frame
            T_obj = cell(1,N); % object frame
            X = cell(1,N);
            for k=1:N
                T_isa{k}  = opti.variable(3,4); % instantaneous screw axis frame
                T_obj{k}  = opti.variable(3,4); % object frame
                X{k} =  [vec(T_isa{k});vec(T_obj{k})];
            end

            % System controls U (unknown invariants at every time step)
            U = opti.variable(6,N-1);

            % System parameters P (known values that need to be set right before solving)
            T_obj_m = cell(1,N); % measured object orientation
            h = opti.parameter(1,1);
            for k=1:N
                T_obj_m{k}  = opti.parameter(3,4); % measured object frame
            end

            %% Specifying the constraints

            % Constrain rotation matrices to be orthogonal (only needed for one timestep, property is propagated by geometric integrator)
            deltaR_isa = T_isa{1}(1:3,1:3)'*T_isa{1}(1:3,1:3) - eye(3);
            deltaR_obj = T_obj{1}(1:3,1:3)'*T_obj{1}(1:3,1:3) - eye(3);
            opti.subject_to([deltaR_isa(1,1:3) deltaR_isa(2,2:3) deltaR_isa(3,3)] == 0)
            opti.subject_to([deltaR_obj(1,1:3) deltaR_obj(2,2:3) deltaR_obj(3,3)] == 0)

            % Dynamic constraints using a multiple shooting approach
            for k=1:N-1
                % Integrate current state to obtain next state
                Xk_end = geom_integr(X{k},U(:,k),h); % geometric integrator

                % "Close the gap" constraint for multiple shooting
                opti.subject_to(Xk_end==X{k+1});
            end

            % Lower bounds on control
            opti.subject_to(U(:,end) == U(:,end-1)); % Last sample has no impact on RMS error

            %% Specifying the objective

            % Fitting constraint to remain close to measurements
            objective_fit_position = 0;
            objective_fit_orientation = 0;
            for k=1:N
                T_obj_k = T_obj{k};
                T_obj_m_k = T_obj_m{k};
                e_position = T_obj_k(1:3,4) - T_obj_m_k(1:3,4); % position error
                e_rotation = T_obj_m_k(1:3,1:3)'*T_obj_k(1:3,1:3) - eye(3); % rotation error
                e_rotation = vec(triu(e_rotation));
                objective_fit_position = objective_fit_position + dot(e_position,e_position);
                objective_fit_orientation = objective_fit_orientation + dot(e_rotation,e_rotation); % apply weighting to error
            end
            opti.subject_to(objective_fit_orientation/N/(rms_rot^2) < 1); %
            opti.subject_to(objective_fit_position/N/(rms_pos^2) < 1);

            % Regularization constraints to deal with singularities and noise
            objective_reg = 0;
            for k=1:N-1
                e_regul_abs = U([2 3 5 6],k); % absolute value invariants (force arbitrary invariants to zero)
                objective_reg = objective_reg + e_regul_abs(1)^2 + e_regul_abs(2)^2 + ...
                    1/L^2*(e_regul_abs(3)^2 + e_regul_abs(4)^2);
            end
            objective = objective_reg/(N-1);

            %% Define solver
            opti.minimize(objective);
            opti.solver('ipopt',struct('print_time',0,'expand',true),struct('max_iter',max_iters,'tol',10e-5,'print_level',0));

            %% Save the variables and parameters in a struct
            var.T_obj = T_obj;
            var.T_isa = T_isa;
            var.U = U;
            
            param.T_obj_m = T_obj_m;
            param.h = h;
            
end