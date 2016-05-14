function [xres yres]= map_coord(x, y, omap)
% By Yiren Lu at University of Pennsylvania
% Mar 18 2016
% ESE 650 Project 4

% This function converts senser's coordinates to map's coordinates
% and sort out the bad points;

xres = ceil((x-omap.minx)./omap.res);
yres = ceil((y-omap.miny)./omap.res);
indGood = (xres > 1) & (yres > 1) & (xres < omap.sizex) & (yres < omap.sizey);
xres = xres(indGood);
yres = yres(indGood);
end