function [x y yaw dx dy dyaw ranges angles rpy] = get_odometry_data(lidar, ts, head_angles)
% By Yiren Lu at University of Pennsylvania
% Mar 18 2016
% ESE 650 Project 4

% Preprocess data from odometry, and correct it according to imu's yaw


n_lidar = numel(lidar);
pose = zeros(n_lidar,3);
yaw = zeros(n_lidar, 1);
rpy = zeros(n_lidar, 3);
for i = 1:n_lidar
    pose(i,:) = lidar{i}.pose;
end
for i = 1:n_lidar
%     yaw(i) = pose(i,3); 
    yaw(i) = lidar{i}.rpy(3);
    rpy(i,:) = lidar{i}.rpy;
end
% correct odometry data
wrong_global = pose(2:end,:) - pose(1:end-1,:);

dxdy_local = zeros(size(pose,1),2);
for i = 1:size(pose,1)-1
    yaw_wrong = lidar{i}.pose(3);
    dxdy_local(i,:) = [cos(yaw_wrong) sin(yaw_wrong); -sin(yaw_wrong) cos(yaw_wrong)]* wrong_global(i,1:2)';
end

dxdy_global = zeros(size(pose,1),2);
xy_global = zeros(size(pose,1),2);
for i = 1:size(pose,1)-1
     dxdy_global(i,:)=[cos(yaw(i)) -sin(yaw(i)); sin(yaw(i)) cos(yaw(i))]*dxdy_local(i,:)';
     xy_global(i+1,:) = xy_global(i,:)+dxdy_global(i,:);
end
x = xy_global(:,1);
y = xy_global(:,2);
dx = dxdy_local(:,1);
dy = dxdy_local(:,2);
dyaw = zeros(size(pose,1),1);
dyaw(2:end) = yaw(2:end) - yaw(1:end-1);



% correct ranges data according to the head_angles

angles = zeros(1081, numel(lidar));
ranges = zeros(1081, numel(lidar));

for i = 1:numel(lidar)
[head_angle idx] = find_head_angle(ts, head_angles, lidar{i}.t);
angles(:,i) = [-135:0.25:135]'*pi/180+head_angle(1);
ranges(:,i) = double(lidar{i}.scan');         %%%%%% DATA TYPE: double

pitch = head_angle(2) + rpy(i,2);

ranges(:,i) = sqrt(ranges(:,i).^2 ./ (1 + tan(pitch)^2 * cos(angles(:,i)).^2 ) );
end



end