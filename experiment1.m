% EXPERIMENT_1 Script runs mathematical simulation based on the work of 
% Morgan et al. 2014. (Quantitative single-exposure x-ray phase contrast 
% imaging using a single attenuation grid). 
%
% author: Ana Skaro, 2017


% Microscope parameters initialization
initialize_microscope;
fprintf('Initialized!\n')
% Calculation of reference centers. In this synthetic experiment, centers
% are the same for all holes in the attenuation grid.
[c_x_ref,c_y_ref]=create_reference_windows;
% Creation of transparent object (sample)
T=create_lens;
% Placement of the object (sample).
[object_mask] = apply_lens(T,0,0);
fprintf('Object applied!\n')
%% Object masks calculation
fprintf('Slicing!\n')
fprintf('. . .\n')
% Creating object mask for each hole in the attenuation grid.
object_masks = slice_object_mask(object_mask); % object_masks(1024,1024,64)
% Freeing the memory
clearvars object_mask
fprintf('Masks sliced!\n')
%% Iterative phase
global N_holes N_holes_side signal

phis_x = zeros(N_holes,1)';
phis_y = zeros(N_holes,1)';

fprintf('Starting calculations for each hole.\n')
fprintf('. . .\n')
for hole = 1:N_holes
    hole
    % choose object mask for current hole
    mask = object_masks(:,:,hole);      
    % apply object mask
    signal_after_object = mask .* signal;
    % propagation of light
    sensor = propagate_light_through_space(signal_after_object);
    
    %figure, imagesc(abs(sensor)), colormap gray, hold on
    [center_x,center_y] = center_of_mass(abs(sensor)); 
    %plot(center_x,center_y,'r*')
    [phis_x(hole), phis_y(hole)] = calculate_phi(center_x, center_y, c_x_ref, c_y_ref);
end
%% Show the results!
phi_x = reshape(phis_x,[N_holes_side,N_holes_side])';
phi_y = reshape(phis_y,[N_holes_side,N_holes_side])';
fprintf('Calculations done!!!\n')
figure, imagesc(phi_x), title('Phi_x');
figure, imagesc(phi_y), title('Phi_y');
phase_grad = sqrt(phi_x.^2 + phi_y.^2);
figure, surf(phase_grad);
fprintf('*Experiment over*\n')