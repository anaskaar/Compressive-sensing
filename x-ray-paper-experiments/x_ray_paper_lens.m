%% Load data
clear, clc
load('centers_x.mat','centers_x')
centers_x_ref = centers_x;
load('centers_y.mat','centers_y')
centers_y_ref = centers_y;
load('image_ref.mat','image_ref')
image_reference = image_ref;
figure, imagesc(abs(image_reference)), colormap gray;
%% Parametar setup
lambda = 632.8e-9;                  % Wavelenth (in m)
sample_distance = lambda/10;        % Distance between samples (in m) 6.328 * 10^-8
k=2*pi/lambda;
                     
z = 0.0001;                          % Sensor distance (m) 0.1 mm = 100 mikro m
f = 0.001;                          % Focal distance

x_len = 2048; y_len = x_len;         % x_len * sample_distance = 2.59*10^-4 m = 0.259 mm = 259 mikro m, za x_len=8192, hole_size=64.7 mikro m (8 rupa)
hole_size = 2048;                   % 1024 => hole_size=64.7 mikro m (8 rupa)


signal = ones(hole_size,hole_size);         % Input signal
%%

%initialize compressive sensing
little_hole = 32; % 1024
N = little_hole*little_hole;
one_side = hole_size/little_hole;
holes_num = one_side * one_side;

 
phi_matrix_x = zeros(one_side,one_side,holes_num);
phi_matrix_y = zeros(one_side,one_side,holes_num);
centers_x = zeros(1,holes_num);
centers_y = zeros(1,holes_num);

%% Phase transformation performed by prism
% T(x,y)= k*n*D(x,y)+k*[D_max - D(x,y)]
% T = exp(1i*k*D_max)*exp(D.*1i*k*(n-1)); (Goodman, page 97, eq. 5-1)
n   = 10;
prism_x = hole_size;
prism_y = hole_size;

D_max = 0.1*z;
D2 = lens_thickness(hole_size,D_max,f, sample_distance,n);
T2 = exp(1i*k*D_max)*exp(D2.*1i*k*(n-1));
%figure, imagesc(angle(T2)), colormap gray
%T2(T2==0) = 1;
T_mask = ones(hole_size);
T2 = 1+T2;
T = horzcat(T_mask(:,1:hole_size/2), T2(:,1:hole_size/2));
%T = T2;
figure, imagesc(angle(T)), colormap gray
%figure, plot(linspace(1,hole_size,hole_size),D_total), title('object 1d REAL');



%% Do calculation in phases


%figure, imagesc(abs(signal)), colormap gray;
%figure, imagesc(abs(T)),colormap gray;
    signal_M = signal .* T;
   
    
    % padding
    add_horz = zeros(hole_size,hole_size);
    add_vert = zeros(2*hole_size,hole_size);

    signal_M = vertcat(signal_M,add_horz);
    signal_M = horzcat(signal_M,add_vert);
    %figure, imagesc(angle(signal_M)), colormap gray, title('Sensor image')
    % Transsmision of light trought empty space
    sensor = fresnel_advance(signal_M, sample_distance, sample_distance,z, lambda);
    % remove padding
    sensor=sensor(1:hole_size,1:hole_size);
    figure, imagesc(abs(sensor)), colormap gray, title('Sensor image')
    Ws = slice_windows(sensor,little_hole);
    [aa,bb,cc] = size(Ws); 
    
    for i = 1:cc
    [centers_x(i),centers_y(i)] = center_of_mass(Ws(:,:,i));   
    end

    % Calculate shift
    centers_x = reshape(centers_x,[one_side,one_side])';
    centers_y = reshape(centers_y, [one_side,one_side])';
    [phi_x, phi_y] = calculate_phi(centers_x, centers_y, centers_x_ref, centers_y_ref, z);
    
    Te = thickness(phi_x,phi_y,k,n);
    figure,imagesc(abs(Te)),colormap gray, title('Thickness 2D');
    Te_1d = max(abs(Te));
    figure, plot(linspace(1,one_side,one_side),Te_1d),  title('Thickness 1D');
    
 %% Calculate Thickness from Te
%Te = (log(Te) - 1i*k*D_max)./(1i*k*(n-1));
 
   
 %% Plot results
 [X,Y] = meshgrid(1:one_side,1:one_side);
 Z = abs(Te);
 figure;
 h = surf(X,Y,Z);
 set(h,'LineStyle','none'), colormap winter, title ('Thickness 3D');
    
  %% Plot results
%  [X,Y] = meshgrid(1:x_len,1:x_len);
%  Z = abs(D2);
%  figure;
%  h = surf(X,Y,Z);
%  set(h,'LineStyle','none'), colormap winter, title ('Thickness 3D REAL');