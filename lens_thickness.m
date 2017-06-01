% D_max is maximum thickness of 'lens' (thin glass)
% D(x,y) is 'lens' (thin glass) thickness function
% n is refraction index of material (n is approx. 1.5 for glass) 
% sphere equation (center in (0,0,0)) x^2+y^2+z^2=r^2 
% z = sqrt(r^2-(x^2+y^2)-z0
function D=lens_thickness(x_len,D_max,f,sample_distance,n)
r = abs(f*(1-n));
% generating meshgrid
xs = [1 : x_len/2] * sample_distance;
xs_neg = fliplr(xs).*(-1);
xs = [xs_neg xs];
[XS,YS] = meshgrid(xs);

z0 = r-D_max;
D= sqrt(r^2-(XS.^2+YS.^2))-z0;




