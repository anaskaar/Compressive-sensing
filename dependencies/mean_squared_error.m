function [ MSE ] = mean_squared_error( image_1, image_2 )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
[s_x,s_y] = size(image_1);
[s_x2,s_y2] = size(image_2);
if s_x ~= s_x2 || s_y~=s_y2
    error('Images must be of the same size');
else
    e = double(image_1) - double(image_2);
    MSE = sum(sum(e.*e))/(s_x*s_y);
end

