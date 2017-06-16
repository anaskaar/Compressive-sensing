% cs_sr07 - Rekonstrukcija signala kod sazetog ocitavanja, uz sum. 
%
% Poziva se:
%    [xr,Status] = cs_sr07(yk,B,e);
%    [xr,Status] = cs_sr07(yk,B,e,Ispis);
% gdje je
%    yk     - vektor dobiven sazetim ocitavanjem (M komponenata)
%    B      - matrica koja povezuje sparse bazu i ocitani vektor (M x N)
%    e      - pogreska uzrokovana sumom
%    Ispis  - ako je 1, ispisuju se poruke koje daje SeDuMi
%    xr     - rekonstruirani signal u sparse domeni (N komponenata)
%    Status - sadrzi info koji daje SeDuMi
%
% Algoritam
%    Rekonstrukcija se dobiva rjesavanjem problema
%       max |x|
%        x
%       s.t. ||yk-B*x||<=e
%    Optimizacijski problem rjesava se pomocu funkcije SeDuMi.
%    Formulacija problema opisana je u knjizi 
%       Irina Rish, Genady Ya. Grabarnik,
%       Sparse Modeling - Theory, Algorithms, and Applications,
%       CRC Press, 2015
%       str. 22-23
%    Optimizacijski problem rjesava se pomocu funkcije SeDuMi.
%
% Primjeri poziva
%
% Napomene:
%   1. Koristi se sparse prikaz matrica.
%   2. Koristan podatak je Status.numerr. Ako je 0, optimizacija je uspjesno provedena.
%      Za detalje vidi help sedumi.
%   3. Funkcija se temelji na cs_sr04 kojoj su dodani stosci. 
%   4. Ovo je generalizacija funkcije cs_sr05 uz relaksaciju problema dozvolom da je x<0.
%

function [xr,Status] = cs_sr07(yk,B,e,Ispis)

if nargin==3
   SedumiParametri.fid=0;
else
   SedumiParametri.fid=Ispis;
end

% ======================================================================================
%                            KONDICIONIRANJE PROBLEMA
% ======================================================================================

% Standard dual form of conic programming
%
% Optimization problem
% max b'*x
%  x
% s.t. c-A'*x in cone
%
% is equivalent to problem 
%       zr = arg min z1+z2+...+z2N
%                 z
%       s.t. yk - [B,-B]*z in cone (<= epsilon)
%            z >= 0
% with
%       xr = z(1:N) - z(N+1:2*N) 

[M,N] = size(B);

c  = sparse([zeros(2*N,1);e;yk]);
At = [-speye(2*N);spalloc(1,2*N,0);sparse([B,-B])];
b  = sparse(-ones(2*N,1));

K.l = 2*N;       % number of linear (non-negative) constraints
K.f = 0;         % number of equality constraints
K.q = M+1;       % cone dimension

[z_tmp,z,Status] = sedumi(At,b,c,K,SedumiParametri);

xr = z(1:N) - z(N+1:2*N);
xr=xr(:);





