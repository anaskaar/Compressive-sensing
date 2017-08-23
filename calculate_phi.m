% calculate_phi - Racunanje pomaka centra mase
%
% Poziva se:
%    [phi_x, phi_y] = calculate_phi(x, y, initial_x, initial_y);
% gdje je
%    x     	          - x koordinata centra mase
%    y     		      - y koordinata centra mase
%    initial_x        - inicijalna vrijednost x koordinate centra mase
%    initial_y        - inicijalna vrijednost x koordinate centra mase
%    sample_distance  - Razmak izmedu uzoraka (frekvencija uzrokovanja)
%    phi_x     	      - pomak po x osi u metrima
%    phi_y     		  - pomak po y osi u mentima
%
%   1. Pretpostavlja da je sample_distance definiran u globalnom prostoru
%
% autor Josip Vukusic, 2017
function [ phi_x, phi_y] = calculate_phi( x, y, initial_x, initial_y)

    global sample_distance 
	
    Sx = x - initial_x;
    Sy = y - initial_y;
	
	% Izracun pomaka centra u metrima
    phi_x = Sx.*sample_distance;
    phi_y = Sy.*sample_distance;
    % Izracun promjene kuta
    %phi_x = atan(Sx ./ z);
    %phi_y = atan(Sy ./ z);
    end


