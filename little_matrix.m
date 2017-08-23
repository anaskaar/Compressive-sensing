function [ M ] = little_matrix( vector, group_size, x_shape,y_shape)
%SLICE_WINDOWS Each element in input vector is representing one group of
%elements of size group_size. 
% returns resulting matrix M of size nxn, where n = len(vector)/group_size;
% TODO: Function can be optimized! Use Kronecker product instead!
% author Ana Skaro, 2017
[s_x,len] = size(vector);

if x_shape*y_shape  ~= len * group_size * group_size
    error('Desired shape must be equal to len * group_size^2')
end
 
col_size = y_shape/group_size;
row_size = x_shape/group_size;
M = zeros(x_shape,y_shape);
k = 1;
for i = 0 : row_size-1

    for j = 0:col_size-1
        
        el = vector(k);
        tmp = ones(group_size)*el;
        M(i*group_size+1:group_size*i+group_size,j*group_size+1:group_size*j+group_size)=tmp;
        k = k+1;
    
    end
    
end




  
end


