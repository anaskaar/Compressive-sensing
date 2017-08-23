% EXPERIMENT_2 Script runs the mathematical simulation of the microscopic
% object reconstructin using compressive sensing method. Measurement grids
% are placed between the single attenuation grid and the object (sample).
%
% author: Ana Skaro, 2017
tic
close all
clear,clc


% Microscope parameters initialization
initialize_microscope;
% Compressive sensing parameters initialization
Phi_matrices=initialize_compressive_sensing;
fprintf('Initialized!\n')
%% Calculation of reference centers. 
% Reference centers are calculated for each measurement in Phi_matrices but
% are the same for each hole in the attenuation grid (at least in this
% synthetic experiment).
[c_x_ref, c_y_ref]=create_CS_reference_windows(Phi_matrices);
fprintf('References created!\n')
%% Creation of transparent object (sample)
T=create_lens;
% Placement of the object (sample).
[object_mask] = apply_lens( T, 0, 0 );
figure, imagesc(angle(object_mask));
%%
fprintf('Object applied!\n')
fprintf('Slicing!\n')
fprintf('. . .\n')
% Creating object mask for each hole in the attenuation grid.
object_masks = slice_object_mask(object_mask);  % object_masks(1024,1024,64)
% freeing the memory
clearvars object_mask
fprintf('Masks sliced!\n')
%% Iterative phase!
global CS_M signal N_holes CS_N_holes_one_side
phis_x = zeros(CS_M,N_holes);
phis_y = zeros(CS_M,N_holes);
CS_phi_x = zeros(CS_N_holes_one_side,CS_N_holes_one_side,N_holes);
CS_phi_y = zeros(CS_N_holes_one_side,CS_N_holes_one_side,N_holes);
fprintf('Taking measurements!\n')
fprintf('. . .\n')

holes = (1:N_holes);
% for each hole in the attenuation grid
for i=1:N_holes
    hole=holes(i)
    % choose object mask for current hole
    mask = object_masks(:,:,hole); 
    % for each measurement
    for m=1:CS_M
        % apply measurement mask
        signal_measured = signal.*Phi_matrices(:,:,m);
        % apply object mask
        signal_after_object = mask .* signal_measured;
        % propagate light through space
        sensor = propagate_light_through_space(signal_after_object);
        
        [center_x,center_y] = center_of_mass(abs(sensor));
        [phis_x(m,hole), phis_y(m,hole)] = calculate_phi(center_x, center_y, c_x_ref(m), c_y_ref(m));    
    end
    % do the reconstruction using l1-minimization algorithm
    [CS_phi_x(:,:,hole),CS_phi_y(:,:,hole)]=CS_reconstruction(phis_x(:,hole),phis_y(:,hole));
    
end
fprintf('Measurements taken!\n')
%% Reconstruction of high resolution image
fprintf('Reconstructing image X.\n');
Image_x = reconstruct_from_windows(CS_phi_x);
figure, imagesc(abs(Image_x)), colormap gray, title('Phi_x')
fprintf('Reconstructing image Y.\n');
Image_y = reconstruct_from_windows(CS_phi_y);
figure, imagesc(abs(Image_y)), colormap gray, title('Phi_y')
phase_grad = sqrt(Image_x.^2 + Image_y.^2);
figure, surf(phase_grad);
toc