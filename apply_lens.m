function [object_mask] = apply_lens( T, start_coord_x, start_coord_y )
%APPLY_LENS Places lens into the 2d plane of the attenuation grid at given
%coordinates.
% object_mask = apply_lens(T, start_coord_x, start_coord_y ) places lens T
% in the 2D plane of the attenuation grid at (start_coord_x,start_coord_y)
%
% INPUT
% T - thin object phase modulation
% start_coord_x, start_coord_y - upper left coordinate
% 
% OUTPUT
% object_mask
%
% author: Josip Vukusic, 2017
global signal_len

[size_x, size_y] = size(T);
object_mask = ones(signal_len);
len_x = min(start_coord_x+size_x,signal_len);
len_y = min(start_coord_y+size_y,signal_len);
object_mask(start_coord_x+1: len_x, start_coord_y+1 : len_y) = T(1:len_x-start_coord_x,1:len_y-start_coord_y);

end

