function [ H ] = generate_recursive_haar(N)
% Recursive construction of Haar wavelet matrix
    H = 1; n=log2(N)+1; % Initialization
  
    if n ~= floor(n)
     error('N must be power of 2')
    end

    for k=1:n-1 
        H = [kron(H, [1 1]); 
        kron(eye(size(H,1)), [1 -1])]  / sqrt(2);
    end
end

