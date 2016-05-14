function [c] = get_map_correlation(omap, xs0, ys0)
% By Yiren Lu at University of Pennsylvania
% Mar 18 2016
% ESE 650 Project 4

% Compute the correlation matrix c according to the existing map and
% sensor's data


    
x_im = omap.minx:omap.res:omap.maxx; %x-positions of each pixel of the map
y_im = omap.miny:omap.res:omap.maxy; %y-positions of each pixel of the map
% x_range = -0.2:omap.res:0.2;
% y_range = -0.2:omap.res:0.2;
abs_range = 0.2; % default 0.2
x_range = -abs_range:omap.res:abs_range;
y_range = -abs_range:omap.res:abs_range;
% x_range = 0;
% y_range = 0;
Y = [xs0;ys0;zeros(size(xs0))];

c = map_correlation(omap.map,x_im,y_im,Y(1:3,:),x_range,y_range);


end