function [ W ] = generate_random_weights( n, m )
if( nargin < 2 )
    m = randi(9)+1;
end
W = sprand(n,m,0.5);
W = W ./ sum(W,2);
end