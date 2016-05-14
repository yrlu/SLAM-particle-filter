function display_map(omap, logodd, x0, y0, yaw0, head_angle, rpy, sx,sy,syaw, xyz_rgb)
% By Yiren Lu at University of Pennsylvania
% Mar 19 2016
% ESE 650 Project 4

% tic
colormap hot;

% 
% 
% I = zeros(size(logodd.odd,1), size(logodd.odd,2), 3);
% I(:,:,1) = sigmf(logodd.odd,[20 0]);
% I(:,:,2) = I(:,:,1);
% I(:,:,3) = I(:,:,1);
% 
% [mapx mapy] = map_coord(xyz_rgb(:,1),xyz_rgb(:,2), omap);
% for i = 1:size(xyz_rgb,1)
%     I(mapx(i),mapy(i),:) = xyz_rgb(i,4:6);
% end
% image(I);

% toc
% omap.map = int8(127*sigmf(logodd.odd,[20 0]));
% image(repmat(double(omap.map)/127,1,1,3));



% image(exp(logodd.odd));
imagesc(127*sigmf(logodd.odd,[20 0]));
% imagesc(omap.map);
axis equal;
title(sprintf('head yaw:%f, pitch:%f, imu r:%f, p:%f, y:%f', head_angle(1), head_angle(2), rpy(1),rpy(2),rpy(3)));
hold on;
r = 10;

% for i=1:size(sx,1)
% x0 = sx(i);
% y0 = sy(i);
% yaw0 = syaw(i);
[curx cury] = map_coord(x0, y0, omap);
plot([cury,cury+r*sin(yaw0)],[curx,curx+r*cos(yaw0)],'Color','r','LineWidth',1);
plot([cury-r/4*cos(yaw0), cury+ r/4*cos(yaw0)],[curx+r/4*sin(yaw0), curx-r/4*sin(yaw0)],'Color','r','LineWidth',1);
% end


for i = 1:numel(sx)
    [sx_m,sy_m] = map_coord(sx(i),sy(i),omap);
    plot(sy_m, sx_m,'.r');
end
hold off;
drawnow;
% toc