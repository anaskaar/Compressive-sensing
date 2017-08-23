function [ sensor ] = propagate_light_through_space( signal )
% PROPAGATE_LIGHT_THROUGH_SPACE Function simulates propagation of 2D signal
% through empty space.
% 
%  sensor = propagate_light_through_space(signal) returns light field on
%  the sensor plane. 2D signal is padded with zeros because of the
%  convolution performed by fresnel_advance function but also because of
%  the calculation of center of mass.
%
% INPUT
% signal of size [N,N]
% 
% OUTPUT
% Light field on the sensor plane of size [3*N,3*N]. 
%
% author: Josip Vukusic, 2017

global hole_size sample_distance z lambda
add_horz = zeros(hole_size,hole_size);

signal_M = [add_horz, add_horz, add_horz; add_horz, signal, add_horz;add_horz, add_horz, add_horz];
% Transsmision of light trough empty space
sensor = fresnel_advance(signal_M, sample_distance, sample_distance,z, lambda);

%figure, imagesc(abs(sensor)), colormap gray, title('Sensor image')

end

