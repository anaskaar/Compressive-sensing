clear, clc
%load('x_phase4.mat')
%load('y_phase4.mat')

lambda = 632.8e-9;              % wavelenth (in m)
sample_distance = lambda/10;    % distance between samples (in m) 6.328 * 10^-8
k=2*pi/lambda;

                      
z= 0.0001;                        % sensor distance (m) 0.1 mm = 100 mikro m
f = 0.001;

x_len = 8192;    % x_len * sample_distance = 2.59*10^-4 m = 0.259 mm = 259 mikro m, za x_len=8192, hole_size=64.7 mikro m (8 rupa)
y_len=x_len;
hole_size = 1024; % 1024 => hole_size=64.7 mikro m (8 rupa)
signal = ones(x_len,y_len);
maska = M1(x_len, hole_size,4);

signal = signal .* maska;
figure,imagesc(signal), colormap gray;

%%
% phase transformation performed by prism
% T(x,y)= k*n*D(x,y)+k*[D_max - D(x,y)]
% T = exp(1i*k*D_max)*exp(D.*1i*k*(n-1)); (Goodman, page 97, eq. 5-1)
n = 1.5;
% beta is prism angle
beta = 30;
prism_x = x_len/4;
prism_y = x_len/4;
[D1,D_max] = prism_thickness(prism_x,prism_y,beta, sample_distance); 
T1 = exp(1i*k*D_max)*exp(D1.*1i*k*(n-1));

beta = 20;
[D2,D_max] = prism_thickness(prism_x*3,prism_y*3,beta, sample_distance); 
T2 = exp(1i*k*D_max)*exp(D2.*1i*k*(n-1));
T = horzcat(T1(:,1:1536),T2(1:2048,2436:2947));
%%
ones_pad = ones(x_len-prism_x,prism_x);
T = vertcat(T,ones_pad);
ones_pad = ones(x_len,x_len-prism_x);
T = horzcat(T,ones_pad);
size(T)
%%
%U = signal.*T;
%figure, subplot(2,1,1), imagesc(abs(T)), colormap gray 
%subplot(2,1,2), imagesc(angle(T))

%%

signal = signal.*T;

%figure, subplot(2,1,1),imagesc(angle(signal)),colormap gray;
%subplot(2,1,2), imagesc(abs(signal));
%%
sensor = fresnel_advance(signal, sample_distance, sample_distance,z , lambda);
figure, imagesc(abs(sensor)), colormap gray;
[x, y] = center_of_mass_matrix(abs(sensor), 1024);

Sx = abs(x - x_phase4);
Sy = abs(y - y_phase4);
phi_x = atan(Sx ./ z);
phi_y = atan(Sy ./ z);

%%
%D = [D1(1,1:1536),D2(1,4096:4607)];
%D = [D1(1,1:1536),D2(1,2436:2947)];
%x_os = linspace(1,2048,2048);
%figure, plot(x_os,D)
