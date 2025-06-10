function [ P, UV, N, E, T, W, F ] = import_Mesh( filename )
[ P, UV, N, E, T ] = import_GEO( filename );
[ W, F ]           = import_SKN( filename );
% [ ID, B, E ] = import_PTH( name );
% [P_, N_, W_, D, A, I] = import_CNT( name );
end