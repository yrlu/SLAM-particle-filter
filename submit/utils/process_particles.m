function [newx newy newyaw] = process_particles(dx, dy, dyaw, sx, sy, syaw, fromi, toi, var)
% By Yiren Lu at University of Pennsylvania
% Mar 18 2016
% ESE 650 Project 4


% this function process the particles according to the odometry data
% Inputs:
%       var: [1*3] process noise of dx dy dyaw
%       sx,sy,syaw:     each of n*1 vector of sample data
%       fromi, toi:     from frame fromi to frame toi
%       dx,dy,dyaw:     odometry incremental data

tic
newxy = [sx, sy];
for i = fromi: min(toi, size(dx))
syaw = syaw + dyaw(i);% + normrnd(0, var(3), numel(sx),1); % add random noise?
for j = 1:size(sx)
newxy(j,:) = newxy(j,:) + ([cos(syaw(j)) -sin(syaw(j)); sin(syaw(j)) cos(syaw(j))]*[dx(i);dy(i)])';% + [normrnd(0, var(1)), normrnd(0, var(2))];  % add random noise?
end
end
toc
newx = newxy(:,1)+normrnd(0, var(1), numel(sx),1)*(toi-fromi);
newy = newxy(:,2)+normrnd(0, var(1), numel(sx),1)*(toi-fromi);
newyaw = syaw+normrnd(0, var(3), numel(sx),1)*(toi-fromi);
toc
end