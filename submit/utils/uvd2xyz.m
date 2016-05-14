function [xyz] = uvd2xyz(u, v, d, fc)
% By Yiren Lu at University of Pennsylvania
% Mar 21 2016
% ESE 650 Project 4
% Inputs:
%   uvd:        n*3 uvd points
%   fc:         focal parameters
% Outputs:      
%   points:     n*3 xyz points;


% convert UVDepth to 3d points
% U-> X, V->Z, Depth->Y
% y = Depth/1000; % depth is in mm;
% x = U/fc_1*depth
% z = -V/fc_2*depth

y = d/1000;
x = u/fc(1).*y;
z = -v/fc(2).*y;

xyz = [x y z];

end
