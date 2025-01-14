function [omega,omegadot,omegaddot] = quat_deriv_to_omega_deriv(q,qdot,qddot, qdddot)
% Convert quaternion and derivatives to angular velocities and derivatives
N = size(q,2);
omega = zeros(3,N);
omegadot = zeros(3,N);
omegaddot = zeros(3,N);

for i=1:N
    
    %Quaternions And Dynamics - Basil Graf
    omegaq = 2*hamilton_product(qdot(:,i),quat_conj(q(:,i)));
    omega(:,i) = omegaq(2:4);
    
    omegadotq = 2*hamilton_product(qddot(:,i),quat_conj(q(:,i))) + ...
        2*hamilton_product(qdot(:,i),quat_conj(qdot(:,i)));
    omegadot(:,i) = omegadotq(2:4);
    
    omegaddotq = 2*hamilton_product(qdddot(:,i),quat_conj(q(:,i))) + ...
        4*hamilton_product(qddot(:,i),quat_conj(qdot(:,i))) + ...
        2*hamilton_product(qdot(:,i),quat_conj(qddot(:,i)));
    omegaddot(:,i) = omegaddotq(2:4);
    
end
