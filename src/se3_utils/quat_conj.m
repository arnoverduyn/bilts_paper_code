function q_new = quat_conj(q)
% Convert a quaternion to its complex conjugate

q_new = zeros(4,1);
q_new(1) = q(1);
q_new(2:4) = -q(2:4);

end