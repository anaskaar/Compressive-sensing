A = imread('slika1.png');
B = imread('slika2.png');

A = rgb2gray(A);
B = rgb2gray(B);

% Cross correlation in is equivalent to the convolution. In Fourier domain one of the input
% signals is complex conjugated.
fft_A = fftshift(fft2(A));
fft_B = fftshift(fft2(B));
con_B = conj(fft_B);
f_corr = fft_A .* con_B;
corr = ifft2(ifftshift(f_corr));

[d_x,d_y] = find(corr==max(corr(:)))


figure, imagesc(A);
figure, imagesc(B);
figure,imagesc(abs(corr)), colormap gray;
