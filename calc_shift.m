function [ S,corr ] = calc_shift( mat, ref_mat, hole_size )
%UNTITLED3 Summary of this function goes here
%   Returns S [d_x,d_y,N] containing shifts in x and y dimension for each
%   window.
Ws_ref = slice_windows(ref_mat,hole_size);
Ws = slice_windows(mat,hole_size);
[x_size,y_size,N] = size(Ws_ref);
S = zeros(2,N);

% calculate cross-correlation for each window

for i = 1:N
    
    % Cross correlation in is equivalent to the convolution. In Fourier domain one of the input
    % signals is complex conjugated.
    I_ref=zero_padding(Ws_ref(:,:,i));
    I=zero_padding(Ws(:,:,i));
    fft_A = fft2(I_ref);
    fft_B = fft2(I);
    con_B = conj(fft_B);
    f_corr = fft_A .* con_B;
    corr = ifft2(f_corr);
    %corr = normxcorr2(abs(Ws_ref(:,:,i)), abs(Ws(:,:,i)));
    
    [d_x,d_y] = find(corr==max(corr(:)));
    d_x = d_x-1;
    d_y = d_y-1;
    S(:,i) = [d_x - x_size,d_y - y_size];
    %S(:,1,i)=s_y - d_y;
    

end

S = mod(S,2*hole_size);

end

