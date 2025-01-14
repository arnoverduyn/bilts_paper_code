function [descriptor, ISA_frames] = calculate_ISA_representation(Twist,TwistDot,TwistDotDot)
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
Omegaddot=TwistDotDot(:,1:3);
V=Twist(:,4:6);
Vdot=TwistDot(:,4:6);
Vddot=TwistDotDot(:,4:6);

%Save interim results
omega_1_sq = sum(Omega.^2,2);                             % norm(Omega)^2 [Nx1]
omega_1 = sqrt(omega_1_sq);                               % norm(Omega)   [Nx1]
normOmega_ = repmat(omega_1,1,3);                         % norm(Omega)   [Nx3]
OmegaXOmegadot = cross(Omega,Omegadot,2);                 % Omega x Omegadot       [Nx3]
normOmegaXOmegadot = sqrt(sum(OmegaXOmegadot.^2,2));      % norm(Omega x Omegadot) [Nx1]
normOmegaXOmegadot_ = repmat(normOmegaXOmegadot,1,3);     % norm(Omega x Omegadot) [Nx3]

% Calculate orientation isa-frame
ex = Omega./normOmega_;                                   % Omega/norm(Omega)  [Nx3]
ey = OmegaXOmegadot./normOmegaXOmegadot_;                 % OmegaxOmegadot/norm(OmegaxOmegadot) [Nx3]
ez = cross(ex,ey,2);                                      % ez [Nx3]
ISA_frames = zeros(4,4,N);
for k = 1:N
    ISA_frames(4,4,k) = 1;
    ISA_frames(1:3,1:3,k) = [ex(k,:)',ey(k,:)',ez(k,:)'];
end
    
% Calculate rotational invariants
omega_1omega_2 = -sum(Omegadot.*ez,2);                    % Omega1Omega2 [Nx1]
omega_2 = omega_1omega_2./omega_1;                        % Omega2 [Nx1]
omega_3 = sum(Omegaddot.*ey,2)./(omega_1omega_2);         % Omega3 [Nx1]

% Calculate the position of the isa-frame
p_z = -sum(V.*ey,2)./omega_1;
Vdotz = sum(Vdot.*ez,2);
p_y = sum(V.*ez,2)./omega_1;
Omegadotx = sum(Omegadot.*ex,2);
p_x = -(p_z.*Omegadotx+sum(Vdot.*ey,2))./(omega_1omega_2);
for k = 1:N
    ISA_frames(1:3,4,k) = - ISA_frames(1:3,1:3,k)*[p_x(k);p_y(k);p_z(k)];
end

% Calculate translational invariants
v_1 = sum(V.*ex,2);                                       % V.Omega/norm(Omega)[Nx1]
v_2 = (p_y.*Omegadotx - Vdotz - omega_2.*v_1)./omega_1;   % v_2 [Nx1]
v_3 = (p_z.*sum(Omegaddot.*ex,2)-p_x.*sum(Omegaddot.*ez,2)+sum(Vddot.*ey,2))./omega_1omega_2 - ...
    omega_3.*(v_2./omega_2+v_1./omega_1);

descriptor = [omega_1 omega_2 omega_3 v_1 v_2 v_3]';