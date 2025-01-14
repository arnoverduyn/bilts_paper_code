function descriptor = calculate_DHB_representation(vector)

    % Closed form formulas conform paper
    
    N = size(vector,2);
    
    % calculate a
    a = zeros(1,N);
    for k = 1:N
        a(k) = norm(vector(:,k));
    end
        
    % calculate theta_1
    theta_1 = zeros(1,N-2);
    for k = 1:N-1
        denominator = dot(vector(:,k),vector(:,k+1));
        if abs(denominator) > 10^(-10)
            theta_1(k) = atan(norm(cross(vector(:,k),vector(:,k+1)))/denominator);
        else
            theta_1(k) = 0;
        end
    end
    
    % calculate theta_2
    theta_2 = zeros(1,N-2);
    for k = 1:N-2
        denominator = dot(cross(vector(:,k+1),vector(:,k)),cross(vector(:,k+1),vector(:,k+2)));
        if abs(denominator) > 10^(-10)
            theta_2(k) = atan(norm(vector(:,k+1))*dot(vector(:,k+1),cross(vector(:,k),vector(:,k+2)))/denominator);
        else
            theta_2(k) = 0;
        end
    end
    
    % some padding
    descriptor = [a;theta_1,0;theta_2,0,0];

end