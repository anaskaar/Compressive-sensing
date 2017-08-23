function [ center_x,center_y ] = create_reference_windows()
% CREATE_REFERENCE_WINDOWS Function calculates reference centers for x and
% y coordinates. Because this is the synthetic experiment, centers will be
% the same for each hole in the attenuation grid.
%
% INPUT
% global variables lambda, sample_distance, z, signal and hole_size should
% be defined outside. (Microscope initialization function).
% 
% OUTPUT
% [ center_x,center_y ] = x and y coordinates reference coordinates
%
% author: Ana Skaro, 2017

    global lambda sample_distance z signal hole_size
    add_horz = zeros(hole_size,hole_size);
    signal_M = [add_horz, add_horz, add_horz; add_horz, signal, add_horz;add_horz, add_horz, add_horz];

    sensor = fresnel_advance(signal_M, sample_distance, sample_distance,z,lambda);
    %sensor=sensor(1:hole_size,1:hole_size);
    figure, imagesc(abs(sensor)), colormap gray
    [center_x, center_y] = center_of_mass(abs(sensor));
    save('center_x','center_x');
    save('center_y','center_y');

end