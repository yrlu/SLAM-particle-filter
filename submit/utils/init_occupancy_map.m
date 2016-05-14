function [omap] = init_occupancy_map(minx, miny, maxx, maxy, resolution)
% By Yiren Lu at University of Pennsylvania
% Mar 18 2016
% ESE 650 Project 3

% This function generates occupancy map (m by n by 3) matrix. 
% To visualize the occupancy map:  image(omap.map);

% Inputs:
%   resolution:     number of pixels per unit: 0.05
%   minx:           minimum x
%   miny:           minimum y
%   maxx:           maximum x
%   maxy:           maximum y


omap = {};
% omap.map = ones((maxx-minx)*resolution,(maxy-miny)*resolution, 3)*default; 

omap.res = resolution;
omap.minx = minx;
omap.miny = miny;
omap.maxx = maxx;
omap.maxy = maxy;
omap.sizex = ceil((omap.maxx - omap.minx) / resolution + 1);
omap.sizey = ceil((omap.maxy - omap.miny) / resolution + 1);

omap.map = -ones(omap.sizex, omap.sizey, 'int8');

% init MAP
% MAP.res   = 0.05; %meters
% MAP.xmin  = -20;  %meters
% MAP.ymin  = -20;
% MAP.xmax  =  20;
% MAP.ymax  =  20; 
% MAP.sizex  = ceil((MAP.xmax - MAP.xmin) / MAP.res + 1); %cells
% MAP.sizey  = ceil((MAP.ymax - MAP.ymin) / MAP.res + 1);
% 
% MAP.map = zeros(MAP.sizex,MAP.sizey,'int8'); %%%%%% DATA TYPE: char or int8


end