function [ CS_phi_x, CS_phi_y ] = CS_reconstruction( sensed_x, sensed_y )
% CS_RECONSTRUCTION Reconstructs phase gradient using l1-minimization.
%
% INPUT
% [sensed_x, sensed_y] = sensed vectors of samples, each one of size [m,1]
% Global variables CS_N_holes_one_side Theta and invPsi must be defined
% outside.
% 
% OUTPUT
% [CS_phi_x, CS_phi_y] phase shifts reconstructed from sensed shifts
% using l1-minimization algorithm.
%
% author: Ana Skaro, 2017
global CS_N_holes_one_side Theta invPsi
s1_x = cs_sr07(sensed_x,Theta,0,0);
s1_y = cs_sr07(sensed_y,Theta,0,0);


reconstructed_x = invPsi * s1_x;
reconstructed_y = invPsi * s1_y;

CS_phi_x = zeros(CS_N_holes_one_side);
CS_phi_y = zeros(CS_N_holes_one_side);

CS_phi_x(:,:) = reshape(reconstructed_x,[CS_N_holes_one_side,CS_N_holes_one_side])';
CS_phi_y(:,:) = reshape(reconstructed_y,[CS_N_holes_one_side,CS_N_holes_one_side])';

end

