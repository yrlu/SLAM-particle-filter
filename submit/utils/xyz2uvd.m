function [uvd] = xyz2uvd(x, y, z, fc)
% By Yiren Lu at University of Pennsylvania
% Mar 21 2016
% ESE 650 Project 4

% convert XYZ back to UVDepth;
% Y->Depth, X->U, Z->V, ;
% U = X/Depth * fc_1;
% V = Z/Depth * fc_2;

d = y*1000;
u = x./y* fc(1);
v = -z./y* fc(2);


uvd = [u,v,d];

end