function [Phi] = hadamard_measurement_matrix(CS_M,CS_N_holes) 
% HADAMARD_MEASUREMENT_MATRIX Creates Walsh ordered measurement matrix
% 
%
% Phi = hadamard_measurement_matrix(CS_M,CS_N_holes) creates Walsh ordered
% measurement matrix of size [CS_M, CS_N_holes]
%
% INPUT
% Condition CS_M < CS_N_holes must be satisfied.
% 
% OUTPUT
% Measurement matrix Phi. DCT component of Walsh ordered Hadamard matrix is
% removed before the return.
%
% author: Ana Skaro, 2017
Phi=walsh(CS_N_holes);
Phi(Phi<0)=0;
Phi = Phi(2:CS_M+1,:);
end