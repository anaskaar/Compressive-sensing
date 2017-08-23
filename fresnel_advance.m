% fresnel_advance - Fresnelova aproksimacija.
%
% Poziva se:
%    [U] = fresnel_advance(U0, dx, dy, z, lambda);
%    
% gdje je
%    U0     - Poetna vrijednost polja
%    dx     - Rezolucija po x osi (frekvencija uzrokovanja)
%    dy     - Rezolucija po y osi (frekvencija uzrokovanja)
%    z      - Udaljenost na kojoj se racuna vrijednost polja
%    lambda - Valna duljina svjetlost
%
% Algoritam
%		Koristeci Huygens-Fresnelov princip racuna se iznos kompleksnog polja
%		nakon prijeđenje udaljenosti z (izraz 4-15 Introduction to Fourier Optics, Goodman 1996.).
%       Izraz se računa u frekvencijskoj domeni.
%
% autor Josip Vukusic, 2017
function U = fresnel_advance (U0, dx, dy, z, lambda)

% Valni broj
k=2*pi/lambda;

% Velicina ulaznog polja.
[ny, nx] = size(U0);

% Racunanje u,v koordinata u frekvencijskoj domeni
Lx = dx * nx;
Ly = dy * ny;
dfx = 1./Lx;
dfy = 1./Ly;
u = ones(nx,1)*((1:nx)-nx/2)*dfx;
v = ((1:ny)-ny/2)'*ones(1,ny)*dfy;   

O = fftshift(fft2(U0));

H = exp(1i*k*z).*exp(-1i*pi*z*lambda*(u.^2+v.^2));  

% Racunanje konvolucije u frekvencijskoj domeni
U = ifft2(ifftshift(O.*H));