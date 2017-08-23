function [ Phi_matrices ] = initialize_compressive_sensing()
%INITIALIZE_COMPRESSIVE_SENSING Function initializes global variables for
% CS experiment.
% RETURNS Measurement matrix Phi

% author: Ana Skaro, 2017

global hole_size CS_N_holes_one_side CS_hole_size CS_N_holes CS_M invPsi Theta
CS_hole_size = 128;
CS_N_holes_one_side = hole_size/CS_hole_size;
CS_N_holes = CS_N_holes_one_side*CS_N_holes_one_side;
CS_M = 32;


%% Generate measurement matrices

%[Phi] = hadamard_measurement_matrix(CS_M,CS_N_holes);
%[Phi] = rand(CS_M,CS_N_holes)>0.5;
Phi = balanced_random(CS_M,CS_N_holes);
%Phi = eye(CS_N_holes);
%load('Phi','Phi');
save('Phi','Phi');

Phi_matrices = zeros(hole_size,hole_size,CS_M); 
for row = 1 : CS_M
    Phi_matrices(:,:,row) = little_matrix(Phi(row,:),CS_hole_size,hole_size,hole_size);
end
invPsi=wmpdictionary(CS_N_holes, 'lstcpt',{'dct'} );

Theta = Phi * invPsi;


end

