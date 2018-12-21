function quadplot(quad,varargin)

x = varargin{1};
y = varargin{2};

if nargin-1 == 3
    z = varargin{3};
end
        

d = quad(:,[1 2 3 4 1])';

switch nargin-1
    case 2
        plot(x(d), y(d), 'r-');
    case 3
        plot3(x(d), y(d), z(d), 'r-');
end    

end



