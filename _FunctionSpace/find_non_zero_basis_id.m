function id = find_non_zero_basis_id(x, x_i, support)

temp = abs(x-x_i);
id = find( temp<= support);

end

