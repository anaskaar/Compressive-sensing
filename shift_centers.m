function [ centers, centers_shift ] = shift_centers( centers,phase, hole_size )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% define centres for windows, depending on phase
if phase == 1
    s_x = hole_size / 2;
    s_y = hole_size / 2;
end

if phase == 2        
    s_x = hole_size+hole_size / 2+1;
    s_y = hole_size/ 2;
end

if phase == 3
    s_x = hole_size / 2;
    s_y = hole_size+hole_size / 2+1;
end

if phase == 4
    s_x = hole_size+hole_size / 2+1;
    s_y = hole_size+hole_size / 2+1;    
end

% 2,N
adding = [s_x;s_y];
[V,N]=size(centers);
centers = mod(centers+repmat(adding,1,N),hole_size*2);

centers_shift = centers - repmat(adding,1,N);
end

