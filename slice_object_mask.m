function [ object_masks ] = slice_object_mask(object_mask)
% SLICE_OBJECT_MASK Slices the object mask to smaller windows.
%
% object_masks = slice_object_mask(object_mask) slices object mask to
% smaller windows. Each window coresponds to one hole in the attenuation
% grid.
%
% INPUT
% object_mask of size [s_x,s_y]
% global variable hole_size should be defined outside of the function
%
% OUTPUT
% object_masks of size [hole_size,hole_size,N] 
%
% author: Josip Vukusic, 2017
global hole_size
[s_x,s_y]=size(object_mask);
N_x = s_x / hole_size;
N_y = s_y / hole_size;
N = N_x*N_y;
% initialization of slices
object_masks = zeros(hole_size,hole_size,N);
k = 1;
for i = 0 :N_x-1
    for j = 0 :N_y-1
        
        object_masks(:,:,k) = object_mask(i*hole_size+1:i*hole_size+hole_size,j*hole_size+1:j*hole_size+hole_size);
        
        k = k+1;
        
    end
end
save('object_mask_tensor','object_masks');
end



