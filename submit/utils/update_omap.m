% function [logodd, omap] = update_omap(omap, logodd, lidar, head_angle, x0, y0, yaw0)
function [logodd, omap] = update_omap(omap, logodd, ranges, angles, x0, y0, yaw0)
% By Yiren Lu at University of Pennsylvania
% Mar 19 2016
% ESE 650 Project 4
% Update the occupancy map according to the best particle



xs0 = x0+(ranges.*cos(angles+yaw0))';
ys0 = y0+(ranges.*sin(angles+yaw0))';

[curx cury] = map_coord(x0, y0, omap);
[xis yis] = map_coord(xs0,ys0, omap);
[xray yray] = getMapCellsFromRay(curx, cury, xis, yis);

inds = sub2ind(size(omap.map),xray,yray);

for p = 1:numel(inds) % free <0
    logodd.odd(inds(p)) = logodd.odd(inds(p)) + logodd.logodd_free;
    logodd.odd(inds(p)) = max(logodd.odd(inds(p)), logodd.logodd_min);
end

for p = 1:numel(xis) %occ >0
    logodd.odd(xis(p),yis(p)) = logodd.odd(xis(p),yis(p)) + logodd.logodd_occ;
    logodd.odd(xis(p),yis(p)) = min(logodd.odd(xis(p),yis(p)), logodd.logodd_max);
end

% logodd.odd = logodd.odd+logodd.logodd_occ*0.2;

% omap.map(logodd.odd>0) = 1; % occ
% omap.map(logodd.odd<0) = -1; % free
% omap.map(logodd.odd==0) = 0; % free

omap.map = int8(127*sigmf(-logodd.odd,[20 0]));

% omap.map = int8(logodd.odd*0.2);

% omap.map = int8(ceil(exp(logodd.odd))*0.2);

% omap.map(sub2ind(size(omap.map),xis,yis)) = 1

end


