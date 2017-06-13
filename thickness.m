function [ T ] = thickness( coef_x, coef_y,k )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
brojnik = fft2(coef_x + coef_y .* 1i);
T = ifft2(brojnik ./(1j*k-k));


end

