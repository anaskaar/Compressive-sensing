%%
% phase transformation performed by lens
% T(x,y)= k*n*D(x,y)+k*[D_max - D(x,y)]
% T = exp(1i*k*D_max)*exp(D.*1i*k*(n-1)); (Goodman, page 97, eq. 5-1)
D_max = 0.1*z;
n = 1.5;
lens_surface = x_len/4;
D = lens_thickness(lens_surface,D_max,f, sample_distance,n); 
% matrix containing transformation coefs for each pixel
T = exp(1i*k*D_max)*exp(D.*1i*k*(n-1));

%% place two lenses in space
%padding with ones
padding = ones(lens_surface,lens_surface);
first_lens = vertcat(padding,T,padding,padding);
second_lens = vertcat(padding,padding,T,padding);
padding= ones(x_len,lens_surface);
T = horzcat(padding,first_lens,second_lens,padding);
size(second_lens)
figure, subplot(2,1,1), imagesc(angle(T)), colormap gray
subplot(2,1,2), imagesc(abs(T))