%% Load data
clear, clc

fprintf('Load reference data.\n');
load('centers_x_CS.mat','centers_x')
centers_x_ref = centers_x;
load('centers_y_CS.mat','centers_y')
centers_y_ref = centers_y;
load('Phi.mat','Phi')
Phimat = Phi;
Phi = Phimat;
fprintf('Data loaded.\n');

%% Parametar setup
fprintf('Setup parameters.\n');
lambda = 632.8e-9;                  % Wavelenth (in m)
sample_distance = lambda/10;        % Distance between samples (in m) 6.328 * 10^-8
k=2*pi/lambda;
                     
z= 0.0001;                          % Sensor distance (m) 0.1 mm = 100 mikro m
f = 0.001;                          % Focal distance

%x_len = 2048; y_len = x_len;         % x_len * sample_distance = 2.59*10^-4 m = 0.259 mm = 259 mikro m, za x_len=8192, hole_size=64.7 mikro m (8 rupa)
signal_len = 2048;                   % 1024 => hole_size=64.7 mikro m (8 rupa)


signal = ones(signal_len,signal_len);         % Input signal
%% First Measurement Grid

M1_hole_size = 32; % 1024
M1_n_one_side = signal_len/M1_hole_size;
M1_n = M1_n_one_side * M1_n_one_side;
fprintf('Parameters set.\n');
%% Phase transformation performed by lens
% T(x,y)= k*n*D(x,y)+k*[D_max - D(x,y)]
% T = exp(1i*k*D_max)*exp(D.*1i*k*(n-1)); (Goodman, page 97, eq. 5-1)
fprintf('Define lens.\n');
n   = 1.5;

D_max = 0.1*z;
D2 = lens_thickness(signal_len,D_max,f, sample_distance,n);
T2 = exp(1i*k*D_max)*exp(D2.*1i*k*(n-1));
%figure, imagesc(angle(T2)), colormap gray
T_mask = ones(signal_len);
T2 = 1+T2;
T = horzcat(T_mask(:,1:signal_len/2), T2(:,1:signal_len/2));
%T = T2;
figure, imagesc(angle(T)), colormap gray
%figure, plot(linspace(1,hole_size,hole_size),D_total), title('object 1d REAL');
fprintf('Lens defined.\n');
%% Compressive Sensing initialization
fprintf('Initialize CS.\n');
cs_group_size = 16;
cs_n_holes_side = M1_hole_size/cs_group_size;
cs_n_windows = cs_n_holes_side * cs_n_holes_side;
cs_n_in_group = cs_group_size * cs_group_size;
cs_N = cs_group_size;
cs_M = cs_n_windows/2;

Phi_matrices = zeros(M1_hole_size,M1_hole_size,cs_M); 
for row = 1 : cs_M
    Phi_matrices(:,:,row) = little_matrix(Phi(row,:),cs_group_size,M1_hole_size,M1_hole_size);
end

psi = generate_recursive_haar(cs_n_windows);
Theta = Phi * psi;
centers_x = zeros(cs_M, cs_n_windows);
centers_y = zeros(cs_M, cs_n_windows);
Te = zeros(cs_n_holes_side,cs_n_holes_side,cs_n_windows);
fprintf('CS initialization done.\n');
%% Do calculation in phases


%figure, imagesc(abs(signal)), colormap gray;
%figure, imagesc(abs(T)),colormap gray;



% LENS
signal_M = signal .* T;
fprintf('Lens placed.\n');

% SLICE TO LITTLE WINDOWS
fprintf('Apply M1 grid to signal (Slice to windows).\n');
Ws = slice_windows(signal_M,M1_hole_size);
fprintf('Windows sliced\n');
% for each measurement

fprintf('Apply M2 grids (measurement matrices) to each window.\n');
for mm = 1:cs_M  
    mm
    mask2 = Phi_matrices(:,:,mm);
    
    % apply CS mask to each window
    for window = 1:M1_n
        %window
        
        signal_M2 = Ws(:,:,window) .* mask2;

        % padding
        add_horz = zeros(M1_hole_size,M1_hole_size);
        add_vert = zeros(2*M1_hole_size,M1_hole_size);

        signal_M2 = vertcat(signal_M2,add_horz);
        signal_M2 = horzcat(signal_M2,add_vert);

        % Transsmision of light trought empty space
        sensor = fresnel_advance(signal_M2, sample_distance, sample_distance,z, lambda);

        % remove padding
        sensor=sensor(1:M1_hole_size,1:M1_hole_size);
        [centers_x(mm,window),centers_y(mm,window)] = center_of_mass(sensor);


    end

end   
    %figure, imagesc(angle(signal_M)), colormap gray, title('Sensor image')
    
 fprintf('Calculating shifts.\n');
% Calculate shifts
for window = 1:M1_n
    window
    measurements_x = centers_x(:,window);
    measurements_y = centers_y(:,window);
    
    % references !! change
    [sensed_x, sensed_y] = calculate_phi(measurements_x, measurements_y, centers_x_ref(:,window), centers_y_ref(:,window), z);
    
    %___l2 NORM SOLUTION___ s2 = Theta\y; %s2 = pinv(Theta)*y    
    s2_x = pinv(Theta)*sensed_x;
    s2_y = pinv(Theta)*sensed_y;
    
    %___BP SOLUTION___
    %s1_x = l1eq_pd(s2_x,Theta,Theta',sensed_x,5e-3,20); % L1-magic toolbox
    %s1_y = l1eq_pd(s2_y,Theta,Theta',sensed_y,5e-3,20); % L1-magic toolbox
    s1_x = cs_sr07(sensed_x,Theta,0,0);
    s1_y = cs_sr07(sensed_y,Theta,0,0);
    %___IMAGE RECONSTRUCTIONS___
    reconstructed_x = zeros(cs_n_windows,1);
    reconstructed_y = zeros(cs_n_windows,1);
    reconstructed_x = reconstructed_x+psi*s1_x;
    reconstructed_y = reconstructed_y+psi*s1_y;
    
    reconstructed_x = reshape(reconstructed_x,[cs_n_holes_side,cs_n_holes_side]);
    reconstructed_y = reshape(reconstructed_y, [cs_n_holes_side,cs_n_holes_side]);
    Te(:,:,window) = thickness(reconstructed_x, reconstructed_y,k,n);
    
    
end
fprintf('Done.\n');
%% Reconstruction
fprintf('Reconstructing image.\n');
Image = reconstruct_from_windows(Te);
figure, imagesc(abs(Image)), colormap gray
 %% Calculate Inverse Thickness from Image
Image2 = (log(abs(Image)) - 1i*k*D_max)./(1i*k*(n-1));
figure, imagesc(angle(Image2)), colormap gray