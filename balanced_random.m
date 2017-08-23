function [Phi] = balanced_random(CS_M, CS_N_holes)
% BALANCED_RANDOM Function creates random measurement matrix with balanced
% number of 0 and 1 elements.
%
% Phi = balanced_random(CS_M,CS_N_holes) creates random measurement matrix 
% with balanced number of 0 and 1 elements of size [CS_M, CS_N_holes].
%
% INPUT
% Condition CS_M <= CS_N_holes must be satisfied.
% 
% OUTPUT
% Measurement matrix Phi. 
%
% author: Ana Skaro, 2017

Phi = zeros(CS_M,CS_N_holes);
for k = 1:CS_M
   v = [ones(1,CS_N_holes/2),zeros(1,CS_N_holes/2)];
   ind = randperm(CS_N_holes);
   v = v(ind);
   Phi(k,:) = v;     
end

end