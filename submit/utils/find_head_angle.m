function [angle, ind] = find_head_angle(head_ts, head_angles, t);
% By Yiren Lu at University of Pennsylvania
% Mar 18 2016
% ESE 650 Project 4

% Since the timestamps of lidar and timestamps from joints are not aligned
% (in fact, the intervals are not equal either), this is a helper function
% to return the correct head angle according to time t.

% Inputs:
%   head_ts: timestamp of joints
%   head_angles:    head_angles(yaw, pitch)
%   t:          target timestamp

% ts_tmp = head_ts-t;
% ind =find(ts_tmp>0);
[~,ind] = min(abs(head_ts-t));
if size(ind) ~= 0
ind = ind(1);
angle = head_angles(:,ind);
else 
    ind = 1;
    angle = [0;0];
end
end