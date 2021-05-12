function [y1, y2] = UniformCrossover(x1, x2, gamma)

    %alpha = rand(size(x1));
    alpha = unifrnd(-gamma, 1+gamma, size(x1));
    
    y1 = round(alpha.*x1 + (1 - alpha).*x2);
    y2 = round(alpha.*x2 + (1 - alpha).*x1);
    
end