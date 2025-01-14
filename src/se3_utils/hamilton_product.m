function result = hamilton_product(q, r)
    % Check that both inputs are 4-element vectors
    if numel(q) ~= 4 || numel(r) ~= 4
        error('Both inputs must be 4-element vectors.');
    end
    
    % Extract individual components
    q0 = q(1);
    q1 = q(2);
    q2 = q(3);
    q3 = q(4);
    
    r0 = r(1);
    r1 = r(2);
    r2 = r(3);
    r3 = r(4);
    
    % Compute the Hamilton product
    result = [q0*r0 - q1*r1 - q2*r2 - q3*r3;
        q0*r1 + q1*r0 + q2*r3 - q3*r2;
        q0*r2 - q1*r3 + q2*r0 + q3*r1;
        q0*r3 + q1*r2 - q2*r1 + q3*r0];
end