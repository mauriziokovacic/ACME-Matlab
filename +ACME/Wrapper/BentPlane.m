function [P,N,T,UV] = BentPlane(Side,Radius,Res)
if((nargin<3)||isempty(Res))
    Res = [4 4];
end
if((nargin<2)||isempty(Radius))
    Radius = 1;
end
if((nargin<1)||isempty(Side))
    Side = 1;
end
Res = Res+1;
x = repmat([-ones(Res(1),1);cos(linspace(pi,3*pi/2,Res(1)+1))';linspace(0,1,Res(1))'],1,Res(2));
y = repmat([linspace(1,0,Res(1))';sin(linspace(pi,3*pi/2,Res(1)+1))';-ones(Res(1),1)],1,Res(2));
z = repmat(linspace(0,1,Res(2)),Res(1)*3+1,1);
c = cat(3,repmat(linspace(0,1,Res(2)),Res(1)*3+1,1),repmat(linspace(0,1,Res(1)*3+1)',1,Res(2)),zeros(size(z)));

[T,P,UV] = surf2patch(x * Side,y * Side - Side/2,z * Side,c);
UV       = UV(:,1:2);
[P,~,UV,T] = soup2mesh(P,zeros(size(P)),UV,T);
N        = vertex_normal(P,T);
end

% function [P,N,T,UV] = BentPlane(Side,Radius,Res)
% if((nargin<3)||isempty(Res))
%     Res = [4 4];
% end
% if((nargin<2)||isempty(Radius))
%     Radius = 1;
% end
% if((nargin<1)||isempty(Side))
%     Side = 1;
% end
% 
% t = 2*Side+Radius*pi/2;
% n = (Res(1)+1);
% 
% V = repmat([linspace(0,Side,n)';...
%             linspace(Side,Side+Radius*pi/2,n)';...
%             linspace(Side+Radius*pi/2,t,n)']/t,...
%            1,Res(2)+1);
% 
% U = repmat(linspace(0,1,Res(2)+1),row(V),1);
% 
% f = {@create_floor,@create_corner,@create_wall};
% 
% X = [];
% Y = [];
% Z = [];
% NX = [];
% NY = [];
% NZ = [];
% for i = 1 : numel(f)
% [x,y,z,nx,ny,nz] = f{i}(Side,Radius,Res);
% X  = [ X; x];
% Y  = [ Y; y];
% Z  = [ Z; z];
% NX = [NX;nx];
% NY = [NY;ny];
% NZ = [NZ;nz];
% end
% P  = [ X(:)  Y(:)  Z(:)];
% N  = [NX(:) NY(:) NZ(:)];
% T  = create_quads(size(X));
% UV = [U(:) V(:)];
% 
% end
% 
% function [x,y,z,nx,ny,nz] = create_floor(Side,Radius,Res)
% x  = repmat(linspace(-Side,0,Res(1)+1)',1,Res(2)+1);
% y  = repmat(repmat(-Radius,Res(1)+1,1),1,Res(2)+1);
% z  = repmat(-Side/2+linspace(0,1,Res(2)+1)*Side,Res(1)+1,1);
% nx = zeros(size(x));
% ny = ones(size(y));
% nz = zeros(size(z));
% end
% 
% function [x,y,z,nx,ny,nz] = create_corner(Side,Radius,Res)
% alpha = linspace(3/2*pi,2*pi,Res(1)+1)';
% c     = cos(alpha);
% s     = sin(alpha);
% x     = repmat(Radius*c,1,Res(2)+1);
% y     = repmat(Radius*s,1,Res(2)+1);
% z     = repmat(-Side/2+linspace(0,1,Res(2)+1)*Side,Res(1)+1,1);
% nx    = repmat(-c,1,Res(2)+1);
% ny    = repmat(-s,1,Res(2)+1);
% nz    = zeros(size(z));
% end
% 
% function [x,y,z,nx,ny,nz] = create_wall(Side,Radius,Res)
% x  = repmat(repmat(Radius,Res(1)+1,1),1,Res(2)+1);
% y  = repmat(linspace(0,Side,Res(1)+1)',1,Res(2)+1);
% z  = repmat(-Side/2+linspace(0,1,Res(2)+1)*Side,Res(1)+1,1);
% nx = -ones(size(x));
% ny = zeros(size(y));
% nz = zeros(size(z));
% end
% 
% function [Q] = create_quads(Res)
% m = Res(1);
% n = Res(2);
% i = setdiff(1:(m*n),[sub2ind([m n],1:m,repmat(n,1,m)),sub2ind([m n],repmat(m,1,n),1:n)])';
% Q = [i i+m i+m+1 i+1 ];
% end