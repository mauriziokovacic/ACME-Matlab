function [ax] = apply_to_axes(obj,ax,t)
if( nargin < 3 )
    t = 0;
end
[NA, VA] = obj.getData(t);
ax = set( ax, NA, VA );
end