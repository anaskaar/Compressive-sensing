function [ centers_ref_x, centers_ref_y ] = create_CS_reference_windows(Phi_matrices)
%CREATE_CS_REFERENCE_WINDOWS Function calculates reference centers (x and
% y coordinates) for each CS measurement mask. Because this is the 
% synthetic experiment, centers will be the same for each hole in the 
% attenuation grid. 
%
% INPUT
% global variables lambda, sample_distance, z, signal hole_size CS_M should
% be defined outside. (Microscope and CS initialization function).
% 
% OUTPUT
% [centers_ref_x, centers_ref_y]=(x,y) reference coords for each 
% measurement
%
% author: Ana Skaro, 2017
global hole_size CS_M sample_distance lambda z signal
centers_ref_x = zeros(CS_M,1);
centers_ref_y = zeros(CS_M,1);
for m = 1:CS_M
    
    signal_M = signal .* Phi_matrices(:,:,m);
    %add padding
    add_horz = zeros(hole_size,hole_size);
    signal_M = [add_horz, add_horz, add_horz; add_horz, signal_M, add_horz;add_horz, add_horz, add_horz];
    %propagate through space
    sensor = fresnel_advance(signal_M, sample_distance, sample_distance,z,lambda);
    
    [centers_ref_x(m), centers_ref_y(m)] = center_of_mass(abs(sensor)); 
end
save('centers_CS_ref_x','centers_ref_x');
save('centers_CS_ref_y','centers_ref_y');
   
end

