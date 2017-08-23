% lena_test - compressive sensing method on image lena.png
% 
% author: Ana Skaro, 2017

close all
clear,clc
global signal CS_N_holes CS_M CS_N_holes_one_side invPsi Theta N_holes

signal = rgb2gray(imread('lena.png'));
signal = signal(256:319,256:319);
%%
% number of measurements
CS_M = 128;
CS_N_holes_one_side = 16;
CS_N_holes = CS_N_holes_one_side*CS_N_holes_one_side;

%% Create design matrix Theta

% creates random measurement matrix 
% Phi = rand(CS_M,CS_N_holes) > 0.5;
% creates random measurement matrix with balanced number of 0 i 1 elements
% Phi = balanced_random(CS_M,CS_N_holes);
% creates Hadamard measurement matrix
Phi = hadamard_measurement_matrix(CS_M,CS_N_holes);
% transform measurement matrix rows to 2D measurement masks
Phi_matrices = zeros(CS_N_holes_one_side,CS_N_holes_one_side,CS_M); 
for m = 1 : CS_M
   one_m = Phi(m,:);
   Phi_matrices(:,:,m) = reshape(one_m,[CS_N_holes_one_side,CS_N_holes_one_side])';   
end

invPsi=wmpdictionary(CS_N_holes, 'lstcpt',{'db2'} );
Theta = Phi(1:CS_M,:)*invPsi;

fprintf('Initialized!\n')
% slice image to windows
windows = slice_lena(signal,CS_N_holes_one_side);  
fprintf('Windows sliced!\n')
%% Iterative phase
N_holes = 16;

sensed = zeros(CS_M,N_holes);
result = zeros(CS_N_holes_one_side,CS_N_holes_one_side,N_holes);

fprintf('Taking measurements!\n')
fprintf('. . .\n')

% take measurements for each window (hole)
for hole=1:N_holes
    hole
    lena = windows(:,:,hole);  
    for m=1:CS_M
         signal_measured = lena.*Phi_matrices(:,:,m);

         sensed(m,hole) = sum(sum(signal_measured));
    end
    [result(:,:,hole)]=lena_CS_reconstruction(sensed(:,hole));
    
end
fprintf('Measurements taken!\n')
%% Reconstruction
fprintf('Reconstructing image X.\n');
Image_x = reconstruct_from_windows(result);
h=figure;
imagesc(abs(Image_x)), colormap gray, title(sprintf('Phi = hadamard, Psi = db2, m = %d/%d',CS_M,CS_N_holes));
%% Calc error
MSE = mean_squared_error(signal,Image_x);
s = sprintf('MSE is %f\n',MSE);
fprintf(s);