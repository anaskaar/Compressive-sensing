% D_max is maximum thickness of prism (thin glass)
% D(x,y) is 'prism' (thin glass) thickness function
% k is tg^-1(alpha), where alpha is prism angle
% line equation D(y) = k*y + y0;
% z = sqrt(r^2-(x^2+y^2)-z0
function [D,D_max]=prism_thickness(x_len,y_len,beta,sample_distance)
k=tand(90-beta);
% generating meshgrid
xs = [1 : x_len/2] * sample_distance;
ys = [1: y_len/2]*sample_distance;
xs_neg = fliplr(xs).*(-1);
ys_neg = fliplr(ys).*(-1);
xs = [xs_neg xs];
ys = [ys_neg ys];
[XS,YS] = meshgrid(xs,ys);
y0=YS(1);
D=zeros(x_len,y_len);
D(:)= YS./k-y0/k;
D=transpose(D);
D_max=D(end,end);




