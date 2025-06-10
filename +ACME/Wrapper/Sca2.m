function [S] = Sca2(scale,type)
S = diag([scale,1]); 
if( nargin < 2 )
    type = 'linear';
end
if( strcmpi(type,'linear') )
    S = linearize_transformation_matrix(S);
end
end