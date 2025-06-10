function [P,T,N,UV] = curve2patch(C,t,varargin)
[P,N]    = C.fetchData({'Point','Normal'},num2cell(t,2),varargin{:});
P        = cell2mat(cellfun(@(p) reshape(p,1,row(p),col(p)),...
                            P, 'UniformOutput',false));
N        = cell2mat(cellfun(@(n) reshape(n,1,row(n),col(n)),...
                            N, 'UniformOutput',false));
[U,V]    = meshgrid(linspace(0,1,col(t)),linspace(0,1,numel(C)));
UV       = cat(3,U,V);

G  = griddedInterpolant({linspace(0,1,row(t)),linspace(0,1,col(t)),1:3},P,'spline','nearest');
P  = G({linspace(0,1,numel(C)),linspace(0,1,50),1:3});
G  = griddedInterpolant({linspace(0,1,row(t)),linspace(0,1,col(t)),1:3},N,'spline','nearest');
N  = G({linspace(0,1,numel(C)),linspace(0,1,50),1:3});
G  = griddedInterpolant({linspace(0,1,row(t)),linspace(0,1,col(t)),1:2},UV,'spline','nearest');
UV = G({linspace(0,1,numel(C)),linspace(0,1,50),1:2});
[P,T,UV] = grid2mesh(P, UV);
N        = grid2mesh(N);
end