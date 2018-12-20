function hexaplot(hexa,varargin)

x = varargin{1};
y = varargin{2};
z = varargin{3};
        
d = hexa(:,[1 2 3 4 1])';
plot3(x(d), y(d), z(d), 'r--');    

d = hexa(:,[5 6 7 8 5])';

plot3(x(d), y(d), z(d), 'r--'); 

d = hexa(:,[1 5])';

plot3(x(d), y(d), z(d), 'r--'); 

d = hexa(:,[2 6])';

plot3(x(d), y(d), z(d), 'r--'); 

d = hexa(:,[3 7])';

plot3(x(d), y(d), z(d), 'r--'); 

d = hexa(:,[4 8])';

plot3(x(d), y(d), z(d), 'r--'); 

end



