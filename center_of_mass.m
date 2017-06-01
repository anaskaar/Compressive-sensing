function [ x,y ] = center_of_mass( M )

[s_x,s_y] = size(M);
m00 = sum(M(:));
S_y = 0;
S_x = 0;
for i=1:s_x
    for j=1:s_y
        S_x = S_x + i*M(i,j);
        S_y = S_y + j*M(i,j);
    end
end
x = round(S_x / m00);
y = round(S_y / m00);

end