function P_x = skew(p)
P_x = [0, -p(3), p(2);
    p(3), 0 ,-p(1);
    -p(2), p(1), 0];
end