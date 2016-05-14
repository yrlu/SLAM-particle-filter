
% By Yiren Lu at University of Pennsylvania
% Mar 19 2016
% ESE 650 Project 4

% This is the script for SLAM, the results are in ./results
% Please also check ground_detection.m

% clear
clear;
clc;
addpath ./mex
addpath ./utils

% read data

dataset = 0;
% load(sprintf('train_lidar%d.mat', dataset));
% load(sprintf('train_joint%d.mat', dataset));
load test_lidar.mat;
load test_joint.mat;

[x y yaw dx dy dyaw ranges_all angles_all rpy] = get_odometry_data(lidar,ts, head_angles);

%% occupancy map parameters
resolution = 0.05;
minx = -20;
miny = -20;
maxx = 20;
maxy = 20;
n_samples= 50;
% n_samples = 1;
% process_var = [[1 1]*1e-5 5e-5]; % good
process_var = [[1 1]*1e-5 5e-5];
% process_var = [0 0 0];
% init occupancy map 
omap = init_occupancy_map(minx, miny, maxx, maxy, resolution);

% init logodds 
p11 = 0.65% P(occupied|measured occupied);
p00 = 0.7;% P(free|measured free);
% logodd = init_logodd(omap.sizex, omap.sizey, p11, p00, 127); %good
logodd = init_logodd(omap.sizex, omap.sizey, p11, p00, 500); %good

interval = 100;
displayinterval = interval*10;

% x0, y0, yaw0 is the best particle
x0 = x(1);
y0 = y(1);
yaw0 = yaw(1);

% generate particles
[sx sy syaw] = init_sampling(omap, n_samples, x0, y0, yaw0, [0 0 0]);
sweights = ones(n_samples, 1)/n_samples;
for i = 1:interval:size(x,1);
%     i = mod(idx,  size(x,1));
    i
    % update current map 
    
    [~ ,ind] = max(sweights);
    x0 = sx(ind);
    y0 = sy(ind);
    yaw0 = syaw(ind);
%     end 
%     tic
    
    % 
    [head_angle idx] = find_head_angle(ts, head_angles, lidar{i}.t);
    ranges = ranges_all(:,i);
    angles = angles_all(:,i);
    
    
    indValid_p = (ranges < 30) & (ranges> 0.5);
    % ranges and angles for processs
    ranges_p = ranges(indValid_p);
    angles_p = angles(indValid_p);

    % ranges and angles for correlation
%     indValid_c = (ranges < 30) & (ranges> 1); % & (abs(angles)>pi/2) ;
    indValid_c = (ranges < 10) & (ranges> 1); % good
    ranges_c = ranges(indValid_c);
    angles_c = angles(indValid_c);

%     toc
    % process
    [logodd, omap]=update_omap(omap, logodd, ranges_p, angles_p, x0, y0, yaw0);
%     toc
    % reweight all the samples according to their correlation with the map
    
    [sweights] = reweight(omap, sx, sy, syaw, sweights, ranges_c,angles_c);
%     toc
    Neff = sum(sweights)/(sweights'*sweights);
%     sweights
    if Neff < n_samples*0.7
        disp 'resampling';
        index = resample(sweights,n_samples);
        sx = sx(index);
        sy = sy(index);
        syaw = syaw(index);
        sweights = sweights(index);
        sweights = sweights/sum(sweights);
        
%         sx(1:numel(index)) = sx(index);
%         sy(1:numel(index)) = sy(index);
%         syaw(1:numel(index)) = syaw(index);
%         sweights(1:numel(index)) = sweights(index);
%         [newsx newsy newsyaw] = init_sampling(omap, n_samples - numel(index), x0, y0, yaw0,sample_var);
%         sx(numel(index)+1:end) = newsx;
%         sy(numel(index)+1:end) = newsy;
%         syaw(numel(index)+1:end) = newsyaw;
%         sweights(numel(index)+1:end) = (1-sum(sweights(index)))/(n_samples - numel(index));
    end
%     toc
    % process particles according to the odometry data
    [sx sy syaw] = process_particles(dx, dy, dyaw, sx, sy, syaw, i, i+interval, process_var);
%     toc
    % display
    if mod(i, displayinterval) == 1
        display_map(omap, logodd, x0, y0, yaw0, head_angle, rpy(i,:),sx,sy,syaw, []); 
    end
%     toc
%     imagesc(exp(logodd.odd));
%     hold on;
%     r = 10;
%     [curx cury] = map_coord(x0, y0, omap);
%     plot([cury,cury+r*sin(yaw0)],[curx,curx+r*cos(yaw0)],'Color','r','LineWidth',1);
%     plot([cury-r/4*cos(yaw0), cury+ r/4*cos(yaw0)],[curx+r/4*sin(yaw0), curx-r/4*sin(yaw0)],'Color','r','LineWidth',1);
%     hold off;
%     drawnow
end


