function [ T] = cut_matrix( mat, hole_size, phase )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    [x_size, y_size] = size(mat);
    num_holes = x_size / hole_size;
    
    if(phase == 1 || phase == 3)
        phase_i = 0;
    else
        phase_i = 1;
    end
    
    if(phase == 1 || phase == 2)
        phase_j = 0;
    else
        phase_j = 1;
    end
    
    num_holes_total = (num_holes / 2) ^ 2;
    T = zeros(hole_size, hole_size, num_holes_total);
    
    k = 1;
    for i = 0 : (num_holes / 2) - 1
        for j = 0 : (num_holes / 2) - 1
            cut =  mat(1 + hole_size * (2 * i + phase_i) : hole_size * (2 * i + 1 + phase_i), 1 + hole_size * (2 * j + phase_j) : hole_size * (2 * j + 1 + phase_j));
            T(:,:,k) = cut;
            k = k + 1;
        end
    end

end

