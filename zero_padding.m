function [ I ] = zero_padding( I )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
 [x_len,y_len] = size(I);
 add_horz = zeros(x_len,x_len);
 add_vert = zeros(2*x_len,x_len);

 I = vertcat(I,add_horz);
 I = horzcat(I,add_vert);

end

