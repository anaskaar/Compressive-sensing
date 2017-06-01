function [ Ws ] = slice_windows( M,hole_s )
%SLICE_WINDOWS Function cuts 2d signal to smaller windows size 2*hole_size
%x 2*hole_size.  
% returns 3D matrix size: [2*hs,2*hs,N], where N is (x_len/2*hs) number of
% windows.
% hole_s, s_x and s_y must be pow(2,n).

[s_x,s_y]=size(M);

N_x = s_x / (2*hole_s);
N_y = s_y / (2*hole_s);
N = N_x*N_y;

% initialization of Ws
Ws = zeros(hole_s*2,hole_s*2,N);
k = 1;
for i = 0 :N_x-1
    for j = 0 :N_y-1
        
        Ws(:,:,k) = M(i*hole_s*2+1:i*hole_s*2+hole_s*2,j*hole_s*2+1:j*hole_s*2+hole_s*2);
        
        k = k+1;
        
    end
end
end

