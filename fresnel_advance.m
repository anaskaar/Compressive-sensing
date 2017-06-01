function U = fresnel_advance (U0, dx, dy, z, lambda)
% The function receives a field U0 at wavelength lambda
% and returns the field U after distance z, using the Fresnel
% approximation. dx, dy, are spatial resolution.

k=2*pi/lambda;
[ny, nx] = size(U0); 

Lx = dx * nx;
Ly = dy * ny;

dfx = 1./Lx;
dfy = 1./Ly;

u = ones(nx,1)*((1:nx)-nx/2)*dfx;
v = ((1:ny)-ny/2)'*ones(1,ny)*dfy;  


fprintf('prije')
O = fftshift(fft2(U0));
fprintf('poslije')
H = exp(1i*k*z).*exp(-1i*pi*z*lambda*(u.^2+v.^2));  

fprintf('inv.prije')
U = ifft2(ifftshift(O.*H));
fprintf('inv.poslije')