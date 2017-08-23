% center_of_mass - Racunanje tezinskog centra mase 
%
% Poziva se:
%    [x, y] = center_of_mass(M);
%
% gdje je
%    M     - Ulazna matrica na kojoj se racuna tezinski centar mase
%    x     - x koordinata centra mase
%    y     - y koordinata centra mase
%
% Algoritam
%			Tezinski centar mase se racuna prema formuli:
%			x = (val_M_11 * x_11 + val_M_12 * x_12 + ... val_M_nn * x_nn) / (val_M_11 +val_M_12 .... val_x_nn)
%			y = (val_y_11 * y_11 + val_y_12 * y_12 + ... val_y_nn * y_nn) / (val_M_11 +val_M_12 .... val_M_nn)  
%			gdje je val_M_xy vrijenost matrice M na mjestu x,y (M(x,y)), a x_xy vrijednost koordinate x u tocki (x,y)
%			isto vrijedi za y_xy.
%
% autor Josip Vukusic, 2017
function [ x,y ] = center_of_mass( M )

% Velicina matrice
[s_x,s_y] = size(M);

% Suma vrijednosti svih elemenata
m00 = sum(M(:));

% Inicijalizacija suma
S_y = 0;S_x = 0;

% Računanje svih vrijednosti y koordinate za matricu M
% Vrijednosti su poslagane u jednom vektoru.
koef_y = (1:s_x);
koef_y = repmat(koef_y,[1,s_y]);

% Računanje svih vrijednosti x koordinate za matricu M
% Vrijednosti su poslagane u jednom vektoru.
n=s_y; 
koef_x=(1:s_x)'; % example
koef_x=repmat(koef_x,1,n)';
koef_x = koef_x(:)';

% Izravnavanje matrice u jedan redak
mm = reshape(M,[1,s_x*s_y]);

% Računanje sume umnožaka vrijednosti matrice i koordinata x i y
S_x = mm .* koef_x;
S_y = mm .* koef_y;
S_x = sum(S_x);
S_y = sum(S_y);

% Dijeljenje s ukupnom sumom
x = round(S_x / m00);
y = round(S_y / m00);

end