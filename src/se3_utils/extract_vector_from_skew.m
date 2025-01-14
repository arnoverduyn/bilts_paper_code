function vec = extract_vector_from_skew(skew_matrix)
    vec = [skew_matrix(3,2); skew_matrix(1,3); skew_matrix(2,1)];
end