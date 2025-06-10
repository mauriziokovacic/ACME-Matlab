function [P,N,T,H] = CubeGrid(varargin)
parser = inputParser;
addOptional(parser,'Side',1,@(data) isscalar(data));
addOptional(parser,'Res',[2 2 2],@(data) isnumeric(data)&&(numel(data)==3));
parse(parser,varargin{:});
Side = parser.Results.Side;
Res  = parser.Results.Res;
P = [];
N = [];
T = [];
H = [];
for i = 1 : Res(1)
    for j = 1 : Res(2)
        for k = 1 : Res(3)
            n       = sub2ind(Res,i,j,k)-1;
            toff    = 8*n;
            hoff    = 6*n;
            poff    = ([i j k]-1)*Side;
            [p,n,t] = Cube(Side);
            P       = [P;p+poff];
            N       = [N;n];
            T       = [T;t+toff];
            H       = [H;(1:6)+hoff];
        end
    end
end
[P,~,j] = uniquetol(P,0.0001,'ByRows',true);
T(:) = j(T);
[T,~,j] = unique(T,'rows','stable');
H(:) = j(H);
[~,i,j] = unique(sort(T,2),'rows','stable');
T = T(i,:);
H(:) = j(H);
end