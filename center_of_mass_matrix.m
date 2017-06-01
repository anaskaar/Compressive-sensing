function [ x,y ] = center_of_mass_matrix( M, hole_size )

    hole_size = hole_size*2;
    [x_len, y_len] = size(M);
    num_holes_x = (x_len / hole_size);
    num_holes_y = (y_len / hole_size);
    
    x = zeros(num_holes_x, num_holes_y);
    y = zeros(num_holes_x, num_holes_y);
    

    for i = 0:num_holes_x - 1
        for j = 0:num_holes_y - 1
            [x_val,y_val] = center_of_mass( M((i * hole_size) + 1 : ((i + 1) * hole_size), (j * hole_size) + 1 : ((j + 1) * hole_size)));
            x(i+1,j+1) = x_val;
            y(i+1,j+1) = y_val;
        end
    end
    
    

end

