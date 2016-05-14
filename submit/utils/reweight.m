% function [sweights] = reweight(omap, sx, sy, syaw, sweights, lidar, head_angle)
function [sweights] = reweight(omap, sx, sy, syaw, sweights, ranges, angles)



cs = zeros(size(sx,1),1);

for k =1:size(sx,1)
    xsk = sx(k)+(ranges.*cos(angles+syaw(k)))';
    ysk = sy(k)+(ranges.*sin(angles+syaw(k)))';
    c=get_map_correlation(omap, xsk, ysk);
%     cs(k) = max(c(:));
    cs(k) = norm(c);
end
sweights = cs.*sweights;
sweights = sweights/sum(sweights);

end 