function [fig] = apply_to_figure(obj,fig,t)
if( nargin < 3 )
    t = 0;
end
ax = get( fig, 'CurrentAxes' );
ax = obj.apply_to_axes(ax,t);
fig = set( fig, 'CurrentAxes', ax );
end