function [x y yaw] = init_sampling(omap, n, x0, y0, yaw0, sigma)
% By Yiren Lu at University of Pennsylvania
% Mar 19 2016
% ESE 650 Project 4

% This function generate n random samples according to guassian
% distribution with mean(x0, y0, yaw0) and variance sigma

% Input: 
%       omap:   The occupancy map
%       n:      Number of samples
%       x0,y0,yaw0 :  Gaussian mean
%       sigma:  3*1 Gaussian variance

x = normrnd(x0, sigma(1), n, 1);
y = normrnd(y0, sigma(2), n, 1);
yaw = normrnd(yaw0, sigma(3), n,1);

% The first particle is the mean
x(1) = x0;
y(1) = y0;
yaw(1) = yaw0;
end