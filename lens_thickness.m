% lens_thickness - Funkcija debljine polovice sfere, model debljine lece
%
% Poziva se:
%    [D] = lens_thickness(len,D_max,f,sample_distance,n);
% gdje je
%    len              - Velicina objekta
%    D_max            - Maksimalna debljina objekta
%    f       		  - Zarisna udaljenost
%    sample_distance  - Razmak izmedu uzoraka (frekvencija uzrokovanja)
%    n                - sample_distance
%
% Algoritam
% 		Jednadzba sfere  (centar u tocki (0,0,0)) x^2+y^2+z^2=r^2 
% 		odakle dobivamo z = sqrt(r^2-(x^2+y^2)-z0
%
%
% autor Josip Vukusic, 2017
function [D] = lens_thickness(x_len,D_max,f,sample_distance,n)

r = abs(f*(1-n));
z0 = r-D_max;
% Generiranje indeksa na kojima racunamo iznos funkcije debljine.
% Racunamo samo pola sfere.
xs = [1 : len/2] * sample_distance;
xs_neg = fliplr(xs).*(-1);
xs = [xs_neg xs];
[XS,YS] = meshgrid(xs);

D = sqrt(r^2-(XS.^2+YS.^2))-z0;




