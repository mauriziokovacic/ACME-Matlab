function [h] = frame3( P, U, V, W, type, color )
h = [];
if( ( nargin < 6 ) || ( size(color) ~= [3,3] ) )
    color = [Red();Green();Blue()];
end
if( nargin < 5 )
    type = 'uvw';
end
if( nargin < 4 )
    W = [];
end
if( nargin < 3 )
    V = [];
end
if(nargin==0)
    P = [0 0 0];
    U = [1 0 0];
    V = [0 1 0];
    W = [0 0 1];
end
type = regexprep(type,'[^uvw]','');
if( strcmp( type, '' ) )
    type = 'uvw';
end
r = color(1,:);
g = color(2,:);
b = color(3,:);
u = contains(type,'u');
v = contains(type,'v');
w = contains(type,'w');
if( u && ~isempty(U) )
    h = [h;quiv3( P, U, 'Color', r )];
    if( v || w ) 
        hold on;
    end
end
if( v && ~isempty(V) )
    h = [h;quiv3( P, V, 'Color', g )];
    if( w ) 
        hold on;
    end
end
if( w && ~isempty(W) )
    h = [h;quiv3( P, W, 'Color', b )];
end
end