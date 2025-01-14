function ISA_frames = calculate_ISA_frame(Twist,TwistDot,TwistDotDot)
% Calculate the timebased ISA frames and ISA invariants with analytical formulas using the twist and its derivatives
%
% Input:  Twist,TwistDot,TwistDotDot = the twist and its derivatives for each timestep, three Nx6 matrices, [omegax|omegay|omegaz|vx|vy|vz]
% Output: Invariants = 6 timebased invariants for each timestep, Nx6 matrix, [omega1|omega2|omega3|v1|v2|v3]
%         ISA-frames = ISA-pose matrix, 4x4xN matrix
%
% Original derivation of invariants can be found in "De Schutter ASME2010"
% Efficient notations derived by Arno Verduyn

N = length(Twist(:,1));

%Get Omega and V from Twist, same for the derivatives
Omega=Twist(:,1:3);
Omegadot=TwistDot(:,1:3);
% Omegaddot=TwistDotDot(:,1:3);
V=Twist(:,4:6);
Vdot=TwistDot(:,4:6);
% Vddot=TwistDotDot(:,4:6);

%Save interim results
omega_1_sq = sum(Omega.^2,2);                             % norm(Omega)^2 [Nx1]
omega_1 = sqrt(omega_1_sq);                               % norm(Omega)   [Nx1]
normOmega_ = repmat(omega_1,1,3);                         % norm(Omega)   [Nx3]
OmegaXOmegadot = cross(Omega,Omegadot,2);                 % Omega x Omegadot       [Nx3]
normOmegaXOmegadot = sqrt(sum(OmegaXOmegadot.^2,2));      % norm(Omega x Omegadot) [Nx1]
normOmegaXOmegadot_ = repmat(normOmegaXOmegadot,1,3);     % norm(Omega x Omegadot) [Nx3]

% Calculate orientation isa-frame
ex = Omega./normOmega_;                                   % Omega/norm(Omega)  [Nx3]
ez = OmegaXOmegadot./normOmegaXOmegadot_;                 % OmegaxOmegadot/norm(OmegaxOmegadot) [Nx3]
ey = cross(ez,ex,2);                                      % ez [Nx3]
ISA_frames = zeros(4,4,N);
for k = 1:N
    ISA_frames(4,4,k) = 1;
    ISA_frames(1:3,1:3,k) = [ex(k,:)',ey(k,:)',ez(k,:)'];
end
    
% Calculate rotational invariants
omega_1omega_2 = sum(Omegadot.*ey,2);                    % Omega1Omega2 [Nx1]

% Calculate the position of the isa-frame
p_y = sum(V.*ez,2)./omega_1;
p_z = -sum(V.*ey,2)./omega_1; 
Omegadotx = sum(Omegadot.*ex,2);
p_x = (p_y.*Omegadotx-sum(Vdot.*ez,2))./(omega_1omega_2);
for k = 1:N
    ISA_frames(1:3,4,k) = - ISA_frames(1:3,1:3,k)*[p_x(k);p_y(k);p_z(k)];
end

% % Calculate translational invariants
% v_1 = sum(V.*ex,2);                                       % V.Omega/norm(Omega)[Nx1]
% v_2 = (p_y.*Omegadotx - Vdotz - omega_2.*v_1)./omega_1;   % v_2 [Nx1]
% v_3 = (p_z.*sum(Omegaddot.*ex,2)-p_x.*sum(Omegaddot.*ez,2)+sum(Vddot.*ey,2))./omega_1omega_2 - ...
%     omega_3.*(v_2./omega_2+v_1./omega_1);
% 
% Invariants=[omega_1 omega_2 omega_3 v_1 v_2 v_3];

% % % %%%%%%%%%%%%%%%%%%%%
% % Old implementation
% % %%%%%%%%%%%%%%%%%%%%%%
% 
% %Get Omega and V from Twist, same for the derivatives
% Omega=Twist(:,1:3);
% Omegadot=TwistDot(:,1:3);
% Omegaddot=TwistDotDot(:,1:3);
% V=Twist(:,4:6);
% Vdot=TwistDot(:,4:6);
% Vddot=TwistDotDot(:,4:6);
% 
% %Save interim results
% normOmega = sqrt(sum(Omega.^2,2));                        % norm(Omega)
% normOmega_ = repmat(normOmega,1,3);                       % norm(Omega)
% normOmegadot = sqrt(sum(Omegadot.^2,2));                  % norm(Omegadot)
% normOmegadot_ = repmat(normOmegadot,1,3);                 % norm(Omegadot)
% OmegaXOmegadot = cross(Omega,Omegadot,2);                 % Omega x Omegadot
% normOmegaXOmegadot = sqrt(sum(OmegaXOmegadot.^2,2));      % norm(Omega x Omegadot)
% normOmegaXOmegadot_ = repmat(normOmegaXOmegadot,1,3);     % norm(Omega x Omegadot)
% OmegaXV = cross(Omega,V,2);                               % Omega x V
% OmegadotXV = cross(Omegadot,V,2);                         % Omegadot x V
% OmegaXVdot = cross(Omega,Vdot,2);                         % Omega x Vdot
% OmegaOmegadot = dot(Omega,Omegadot,2);                    % Omega . Omegadot
% OmegaOmegadot_ = repmat(OmegaOmegadot,1,3);               % Omega . Omegadot
% OmegaXOmegaddot = cross(Omega,Omegaddot,2);               % Omega x Omegaddot
% OmegaXOmegaXOmegadot = cross(Omega,OmegaXOmegadot);       % Omega x (Omega x Omegadot)
% OmegaddotXV = cross(Omegaddot,V,2);                       % Omegaddot x V
% OmegadotXVdot = cross(Omegadot,Vdot,2);                   % Omegadot x Vdot
% OmegaXVddot = cross(Omega,Vddot,2);                       % Omega x Vddot
% OmegaXOmegaXOmegaddot = cross(Omega,OmegaXOmegaddot);     % Omega x (Omega x Omegaddot)
% OmegadotxOmegaXOmegadot = cross(Omegadot,OmegaXOmegadot); % Omegadot x (Omega x Omegadot)
% OmegaOmegaddot = dot(Omega,Omegaddot,2);                  % Omega . Omegaddot
% OmegaOmegaddot_ = repmat(OmegaOmegaddot,1,3);             % Omega . Omegaddot
% 
% %Calculate omega1 and ex
% omega_1 = normOmega; % norm(Omega)
% ex = Omega./normOmega_; % Omega/norm(Omega) [vector]
% 
% %Calculation of v1
% v_1 = dot(V,ex,2); % V . Omega/norm(Omega)
% 
% %Calculate omega2 and ey
% omega_2 = normOmegaXOmegadot./normOmega.^2; % norm(Omega x Omegadot)/norm(Omega)^2
% ey = OmegaXOmegadot./normOmegaXOmegadot_; % Omega x Omegadot / norm(Omega x Omegadot)
% 
% %Calculate v2
% Pperpendiculardot = ((OmegadotXV+OmegaXVdot).*normOmega_.^2 - 2*OmegaXV.*OmegaOmegadot_)./normOmega_.^4; % ((Omegadot x V + Omega x Vdot)*normOmega^2 - 2 (Omega x V)(Omega . Omegadot))/normOmega^4
% v_2 = dot(ey,Pperpendiculardot,2); % Ey . pdot|_
% 
% %Calculate omega3
% omega_3 = dot(cross(OmegaXOmegadot,OmegaXOmegaddot,2)./normOmegaXOmegadot_.^2 ,ex ,2); % ((Omega x Omegadot) x (Omega x Omegaddot)) / norm(Omega x Omegadot) . ex
% 
% %Calculate v3
% term1=(3/2) * dot(OmegaXOmegaXOmegadot,normOmega_.^2.*(OmegadotXV+OmegaXVdot)-2*OmegaXV.*OmegaOmegadot_,2) .* OmegaOmegadot*2./(normOmega.^5.*normOmegaXOmegadot.^2) + dot(OmegaXOmegaXOmegadot,normOmega_.^2.*(OmegadotXV+OmegaXVdot)-2*OmegaXV.*OmegaOmegadot_,2)*2.*dot(OmegaXOmegadot,OmegaXOmegaddot,2)./(normOmega.^3.*normOmegaXOmegadot.^4);
% term2=-(dot(OmegadotxOmegaXOmegadot+OmegaXOmegaXOmegaddot , normOmega_.^2.*(OmegadotXV+OmegaXVdot)-OmegaOmegadot_*2.*OmegaXV,2) + dot(OmegaXOmegaXOmegadot,2*OmegaOmegadot_.*(OmegadotXV+OmegaXVdot)+normOmega_.^2.*(OmegaddotXV+2*OmegadotXVdot+OmegaXVddot)-(normOmegadot_.^2+OmegaOmegaddot_)*2.*OmegaXV-2*OmegaOmegadot_.*(OmegadotXV+OmegaXVdot),2))./(normOmega.^3.*normOmegaXOmegadot.^2);
% Pparalleldot = term1 + term2;
% v_3 = dot(ex,Pperpendiculardot,2)-Pparalleldot; % (Ex . pdot|_) - pdot||
% 
% Invariants=[omega_1 omega_2 omega_3 v_1 v_2 v_3];
% 
