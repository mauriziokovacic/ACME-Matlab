function [P,T,N,UV] = curve2mesh(C, n, varargin)
if( nargin<2 )
    n = 20;
end
if( numel(C)<2 )
    error('Must be at least two curves');
end
t        = linspace(0,1,n);
% [P,N]    = C.fetchData({'Point','Normal'},t,varargin{:});
P        = arrayfun(@(c) c.getOrderedPoint(), C, 'UniformOutput', false);
N        = arrayfun(@(c) c.getOrderedNormal(), C, 'UniformOutput', false);
P        = cell2mat(cellfun(@(p) reshape(p,1,row(p),col(p)),...
                            P, 'UniformOutput',false));
N        = cell2mat(cellfun(@(n) reshape(n,1,row(n),col(n)),...
                            N, 'UniformOutput',false));
[U,V]    = meshgrid(t,linspace(0,1,numel(C)));
[P,T,UV] = grid2mesh(P, cat(3,U,V,zeros(size(U))));
N        = grid2mesh(N);
end