function [ M ] = M1( size, hole_size, phase )

    M = zeros(size, size);
    
    num_holes = size / hole_size;
    
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

    
    for i = 0 : (num_holes / 2) - 1
        for j = 0 : (num_holes / 2) - 1
    %for i = 0 : 0
        %for j = 0 : 0
            M(1 + hole_size * (2 * i + phase_i) : hole_size * (2 * i + 1 + phase_i), 1 + hole_size * (2 * j + phase_j) : hole_size * (2 * j + 1 + phase_j)) = 1;
        end
    end
end

