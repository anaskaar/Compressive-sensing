clear,clc
lambda = 632.8e-9;                  % Wavelenth (in m)
sample_distance = lambda;        % Distance between samples (in m) 6.328 * 10^-8
k=2*pi/lambda;
                     
z= 0.0001;                          % Sensor distance (m) 0.1 mm = 100 mikro m
f = 0.001;                          % Focal distance

x_len = 1024; y_len = x_len;         % x_len * sample_distance = 2.59*10^-4 m = 0.259 mm = 259 mikro m, za x_len=8192, hole_size=64.7 mikro m (8 rupa)
hole_size = 128;                   % 1024 => hole_size=64.7 mikro m (8 rupa)
little_hole = 16;
one_side = hole_size/little_hole;
holes_num = one_side * one_side;
signal = ones(hole_size,hole_size);    

add_horz = zeros(hole_size,hole_size);
add_vert = zeros(2*hole_size,hole_size);

signal_M = vertcat(signal,add_horz);
signal_M = horzcat(signal_M,add_vert);

sensor = fresnel_advance(signal_M, sample_distance, sample_distance,z, lambda);
sensor=sensor(1:hole_size,1:hole_size);
image_ref = sensor;
save('image_ref','image_ref');
figure, imagesc(abs(sensor)), colormap gray
Ws = slice_windows(sensor,little_hole);
centers_x = zeros(1,holes_num);
centers_y = zeros(1,holes_num);
%%
for i = 1:holes_num
    [centers_x(i),centers_y(i)] = center_of_mass(Ws(:,:,i));   
end

centers_x = reshape(centers_x,[one_side,one_side])';
centers_y = reshape(centers_y, [one_side,one_side])';
save('centers_x','centers_x');
save('centers_y','centers_y');