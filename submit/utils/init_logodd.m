function [logodd] = init_logodd(sizex, sizey, p11, p00, thres)
% By Yiren Lu at University of Pennsylvania
% Mar 19 2016
% ESE 650 Project 4

logodd = {};
logodd.odd = zeros(sizex, sizey)*log(thres);
logodd.p11 = p11;      % P(occupied|measured occupied);
logodd.p01 = 1-p11;    % P(free|measured occupied);
logodd.p00 = p00;      % P(free|measured free);
logodd.p10 = 1-p00;    % P(occupied|measured free);
logodd.logodd_occ = log(logodd.p11/logodd.p10); % >0
logodd.logodd_free = log(logodd.p01/logodd.p00);% <0
logodd.logodd_max = log(thres);
logodd.logodd_min = -log(thres);
logodd.thres = thres;

end