function [ reconstructed2D] = image_CS_reconstruction( sensed )
% LENA_CS_RECONSTRUCTION Reconstructs image using l1-minimization
% 
%
% reconstructed2D = image_CS_reconstruction(sensed) reconstructs image from
% vector of samples using l1-minimization and returns it as a 2D array.
%
% INPUT
% sensed vector of samples size [m,1]
% Global variables CS_N_holes_one_side Theta and invPsi must be defined.
% 
% OUTPUT
% reconstructed signal returned as 2D array (matrix)
%
% author: Ana Skaro, 2017
global CS_N_holes_one_side Theta invPsi
s = cs_sr07(sensed,Theta,0,0);

reconstructed = invPsi * s;

reconstructed2D = reshape(reconstructed,[CS_N_holes_one_side,CS_N_holes_one_side])';

end

