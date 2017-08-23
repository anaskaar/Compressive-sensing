function [ I ] = reconstruct_from_windows( tensor )
% RECONSTRUCT_FROM_WINDOWS Function reconstructs image I from 3D array of
% 2D windows.
% 
% I = reconstruct_from_windows(tensor) reconstructs (builds) image I of
% size [N,N] from 3D array of 2D windows (of size [M,M,N^2]) row by row.
%
% INPUT
% 3D array (tensor) of image windows of size [M,M,N^2]) 
% 
% OUTPUT
% Image (2D array) of size [N,N]reconstructed from N^2 windows contained in
% 3D array (tensor)
%
% author: Ana Skaro, 2017
[win_size,y,n] = size(tensor);

rowscols = sqrt(n)
N = win_size * rowscols
I = zeros(N);
w = 1;
    for rows = 0 : rowscols-1
        for cols = 0 : rowscols-1
            I(rows*win_size+1:rows*win_size+win_size, cols*win_size+1: cols*win_size+win_size) = tensor(:,:,w);
            w = w+1;
        end

    end
end