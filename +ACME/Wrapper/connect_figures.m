function [h] = connect_figures( h )
if( nargin == 0 )
    h = findobj('Type','figure');
end
if(isempty(h))
    return;
end
ax = get_axes(h);
h = connect_axes(ax);
end