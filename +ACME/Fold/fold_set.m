function [FS] = fold_set(P,T,F,iso_target)
if( nargin < 4 )
    iso_target = 0.5;
end
S  = meandering_triangle(T,F,iso_target);
FS = find_curve(P,T,S);
end