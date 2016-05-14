function [newx newy] = get_newxy_from_dxdy(dx, dy, x0, y0, yaw, fromi, toi)
% By Yiren Lu at University of Pennsylvania
% Mar 18 2016
% ESE 650 Project 4

% This function generate coordinate x y according to (dx dy) and
% indices.

newxy = [x0, y0];
for i = fromi: min(toi, size(dx))
newxy = newxy + ([cos(yaw) -sin(yaw); sin(yaw) cos(yaw)]*[dx(i);dy(i)])';
% newxy = newxy+[dx(i) dy(i)];
end
newx = newxy(1);
newy = newxy(2);
end