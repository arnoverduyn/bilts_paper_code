function [R,Q,p] = eQR(X,regularization,L,p_obj)

    X1 = X(1:3,:);
    Q1 = X1(:,1)/norm(X1(:,1));
    Q2 = X1(:,2)-dot(X1(:,2),Q1)*Q1;
    Q2 = Q2/norm(Q2);
    Q3 = cross(Q1,Q2);
    Q = [Q1,Q2,Q3];
    
    R1 = Q'*X1;
    X2 = X(4:6,:); 
    QTX2 = Q'*X2;
    z = QTX2(2,1)/R1(1,1);
    y = -QTX2(3,1)/R1(1,1);
    x = (QTX2(3,2) + R1(1,2)*y)/R1(2,2);
    p_star = [x;y;z];
    
    if regularization
        delta_p = p_star - Q'*p_obj;
        if norm(delta_p) > L
            delta_p = L*delta_p/norm(delta_p);
        end
        p_star = Q'*p_obj + delta_p;
    end
    
    p = Q*p_star;
    
    R2 = QTX2 - skew(p_star)*R1;
    R = [R1;R2];
end