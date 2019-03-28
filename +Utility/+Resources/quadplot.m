function quadplot(quad,varargin)

x = varargin{1};
y = varargin{2};
dim = 2;
property = 'r-';

if nargin-1 == 3
    if isnumeric(varargin{3})
        z = varargin{3};
        dim = 3;
    else
        property = varargin{3};
        dim = 2;
    end
end
        

d = quad(:,[1 2 3 4 1])';

switch dim
    case 2
        plot(x(d), y(d), property, 'lineWidth', 2);
    case 3
        plot3(x(d), y(d), z(d), 'r-', 'lineWidth', 2);
end    

end



