function [initialized] = initialize_microscope()
% INITIALIZE_MICROSCOPE Function initializes microscope parameters as
% global variables.

% author: Josip Vukusic, 2017
global lambda sample_distance k z signal_len signal hole_size D_max f n lens_dimension N_holes N_holes_side
lambda = 632.8e-9;                  % Wavelenth (in m)
sample_distance = lambda/10;        % Distance between samples (in m) 6.328 * 10^-8
k=2*pi/lambda;
z= 0.0001;                          % Sensor distance (m) 0.1 mm = 100 mikro m
hole_size = 1024;                   % 1024 => hole_size=64.7 mikro m (8 rupa)
signal = ones(hole_size,hole_size); 
signal_len = 1024*4;
D_max = 0.1*z;
f = 0.001;
n = 1.5;
lens_dimension = 1024*4;
N_holes_side = signal_len / hole_size; 
N_holes = N_holes_side*N_holes_side;
initialized = 'Initialized';
end