clear all;
close all;

% This is the script for ground detection, the results are in ./results
% Please place the test rgbd data into ./rgbd directory
% please also check slam_2

addpath('./rgbd');
addpath('./rgbd/cameraParam');

load ./rgbd/DEPTH.mat
run('IRcamera_Calib_Results')


DEPTH_MAX = 4500; % recommended max range
DEPTH_MIN = 400;  % recommended min range


%%

fc_ir = [ 364.457362485643273 ; 364.542810626989194 ];
cc_ir = [ 258.422487561914693 ; 202.487139940005989 ];

fc_rgb = [ 1049.331752604831308 ; 1051.318476285322504 ];
cc_rgb = [ 956.910516428015740 ; 533.452032441484675 ];


for k=[1:20:numel(DEPTH)]
    
    % RGB data is chopped into multiple files because of its size issue
    % Next RGB mat file needs to be loaded every 300 frames
    if mod(k,300)==1
        rgb_file = sprintf('RGB_%d.mat',int32(k/300)+1);
        disp(strcat('loading ',rgb_file,'....'))
        load(rgb_file)
    end
    
    D = DEPTH{k}.depth;
    D(D(:) <= DEPTH_MIN) = 0;
    D(D(:) >= DEPTH_MAX) = 0;  
    D = medfilt2(D,[3 3]);      % if you want to filter noise
    % correct the index
    r_ind = mod(k,300); if r_ind == 0, r_ind = 300; end

    
    D2= D;
    
    % correct the index
    r_ind = mod(k,300); if r_ind == 0, r_ind = 300; end
    R = RGB{r_ind}.image;
    
    sizeR = [1080 1920]
    for j = 1:2:size(D,1)
        for r = 1:2:size(D,2)
            v = j-cc_ir(2);
            u = r-cc_ir(1);
            z = D2(j,r)/1000;
            if abs(v/fc(2)- 1.41/z) < 0.2
                xyz = uvd2xyz(u,v,D2(j,r), fc_ir);
                uvd = xyz2uvd(xyz(:,1),xyz(:,2),xyz(:,3), fc_rgb);
                uvd(1,1:2) = round(bsxfun(@plus, uvd(:,1:2), cc_rgb'));
                if (uvd(1,1)>0 & uvd(1,1)<sizeR(2) & uvd(1,2)>0 & uvd(1,2)<sizeR(1))
%                     uvd
                    R(uvd(1,2),uvd(1,1),:)=[255 0 0];
                end

                D2(j,r) = 20000;
            end
        end
    end
    
    
    
    
    
    figure(1), imagesc(D2);
    figure(2), image(R);
%     drawnow;
    pause(0.2); 
end