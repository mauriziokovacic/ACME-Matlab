function [N] = align_direction(G,Adj,iteration)
if( nargin < 3 )
    iteration = 3;
end
N = align_field(G,G,Adj,iteration);
end