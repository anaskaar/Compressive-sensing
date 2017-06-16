clear,clc
lambda = 632.8e-9;                  % Wavelenth (in m)
sample_distance = lambda/10;        % Distance between samples (in m) 6.328 * 10^-8
k=2*pi/lambda;
                     
z= 0.0001;                          % Sensor distance (m) 0.1 mm = 100 mikro m            

x_len = 2048; y_len = x_len;         % x_len * sample_distance = 2.59*10^-4 m = 0.259 mm = 259 mikro m, za x_len=8192, hole_size=64.7 mikro m (8 rupa)
hole_size = 2048;                   % 1024 => hole_size=64.7 mikro m (8 rupa)
little_hole = 32;
one_side = hole_size/little_hole;
holes_num = one_side * one_side;
signal = ones(hole_size,hole_size);    

%% Compressive Sensing initialization

cs_hole_one_side = 16;
cs_num_holes = little_hole/cs_hole_one_side;
cs_num_windows = cs_num_holes * cs_num_holes;
cs_N_total = cs_hole_one_side * cs_hole_one_side;
cs_N = cs_hole_one_side;
cs_M = cs_num_windows/2;
centers_x = zeros(cs_M,cs_num_windows);
centers_y = zeros(cs_M,cs_num_windows);
%% Generate measurement matrices

%Phi = rand(cs_M,cs_num_windows)>0.5;
%Phi = [1,0,0,1;0,1,1,0];
Phi = measurement_matrix(cs_M,cs_num_windows);
save('Phi','Phi');
Phi_matrices = zeros(little_hole,little_hole,cs_M); 
for row = 1 : cs_M
    Phi_matrices(:,:,row) = little_matrix(Phi(row,:),cs_hole_one_side,little_hole,little_hole);
end
%%
% SLICE TO LITTLE WINDOWS
Ws = slice_windows(signal,little_hole);

% for each measurement
for mm = 1:cs_M  
    mask2 = Phi_matrices(:,:,mm);
    % apply CS mask to each window
    for window = 1:holes_num

        
        signal_M2 = Ws(:,:,window) .* mask2;

        % padding
        add_horz = zeros(little_hole,little_hole);
        add_vert = zeros(2*little_hole,little_hole);

        signal_M2 = vertcat(signal_M2,add_horz);
        signal_M2 = horzcat(signal_M2,add_vert);

        % Transsmision of light trought empty space
        sensor = fresnel_advance(signal_M2, sample_distance, sample_distance,z, lambda);
        %figure, imagesc(abs(sensor)), colormap gray
        % remove padding
        sensor=sensor(1:little_hole,1:little_hole);
        [centers_x(mm,window),centers_y(mm,window)] = center_of_mass(Ws(:,:,window));


    end

end   
save('centers_x_CS','centers_x');
save('centers_y_CS','centers_y');