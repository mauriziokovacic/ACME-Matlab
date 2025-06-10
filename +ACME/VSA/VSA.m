function [Region,Proxy,E] = VSA(P,T,n_region,n_iteration)
if( nargin < 5 )
    Proxy = [];
end
if( nargin < 4 )
    n_iteration = 20;
end
if( nargin < 3 )
    n_region = 10;
end
B      = triangle_barycenter(P,T);
N      = triangle_normal(P,T);
A      = triangle_area(P,T);
Adj    = Adjacency(P,T,'face');
[i,j]  = find(Adj);
Adj    = cell(row(T),1);
for n = 1 : numel(i)
    Adj{i(n)} = [Adj{i(n)};j(n)];
end

i      = randperm(row(T),n_region)';
Region = num2cell(i);
for n = 1 : n_iteration
Proxy      = L21_proxy_fitting(B,N,A,Region);
[Region,E] = geometry_partitioning(B,N,A,Adj,Proxy,Region);
end
end