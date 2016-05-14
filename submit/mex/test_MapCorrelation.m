close all
clear all

load train_lidar0.mat;

angles = [-135:0.25:135]'*pi/180;
ranges = double(lidar{111}.scan');         %%%%%% DATA TYPE: double

% take valid indices
indValid = (ranges < 30) & (ranges> 0.1);
ranges = ranges(indValid);
angles = angles(indValid);

% init MAP
MAP.res   = 0.05; %meters
MAP.xmin  = -20;  %meters
MAP.ymin  = -20;
MAP.xmax  =  20;
MAP.ymax  =  20; 
MAP.sizex  = ceil((MAP.xmax - MAP.xmin) / MAP.res + 1); %cells
MAP.sizey  = ceil((MAP.ymax - MAP.ymin) / MAP.res + 1);

MAP.map = zeros(MAP.sizex,MAP.sizey,'int8'); %%%%%% DATA TYPE: char or int8

% xy position in the sensor frame
xs0 = (ranges.*cos(angles))' ;
ys0 = (ranges.*sin(angles))' ;

% convert position in the map frame here 
Y = [xs0;ys0;zeros(size(xs0))];

%convert from meters to cells
xs1 = (ranges.*cos(angles))'+0.2;
ys1 = (ranges.*sin(angles))'+0.2;

xis = ceil((xs1 - MAP.xmin) ./ MAP.res );
yis = ceil((ys1 - MAP.ymin) ./ MAP.res );

% build an arbitrary map  
indGood = (xis > 1) & (yis > 1) & (xis < MAP.sizex) & (yis < MAP.sizey);
inds = sub2ind(size(MAP.map),xis(indGood),yis(indGood));
MAP.map(inds) = 1;    

x_im = MAP.xmin:MAP.res:MAP.xmax; %x-positions of each pixel of the map
y_im = MAP.ymin:MAP.res:MAP.ymax; %y-positions of each pixel of the map

x_range = -0.2:0.05:0.2;
y_range = -0.2:0.05:0.2;


% INPUT 
% MAP.map           the map 
% x_im,y_im         physical x,y positions of the grid map cells
% Y(1:3,:)          occupied x,y positions from range sensor (in physical unit)  
% x_range,y_range   physical x,y,positions you want to evaluate "correlation" 
%
% OUTPUT 
% c                 sum of the cell values of all the positions hit by range sensor
c = map_correlation(MAP.map,x_im,y_im,Y(1:3,:),x_range,y_range);

%plot original lidar points
figure(1);
plot(xs0,ys0,'.')

%plot map
figure(2);
imagesc(MAP.map);

%plot correlation
figure(3);
surf(c)
disp(max(c(:)))
norm(c)
% [ix iy] = ind2sub(size(c), find(c == max(max(c))));
% norm(ceil(size(c)/2) - [ix iy])