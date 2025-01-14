function omega = extract_omega(R1, R2, ds)
    if norm(R2 * R1') > 10^(-12)
        omega_skew = logm(R2 * R1') / ds;
    else
        omega_skew = zeros(3,3);
    end
    omega = extract_vector_from_skew(omega_skew);
end