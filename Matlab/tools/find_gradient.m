function [x_mid] = find_gradient(x1, y1, g1, x2, y2, g2)
% find mid according to gradient

    x_mid = ((y2-y1)+(g1*x1-g2*x2))/(g1-g2);
end