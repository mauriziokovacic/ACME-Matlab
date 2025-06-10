function CageSpring(Mesh,Cage,W)

c  = row(Cage.Vertex);
C  = Cage.Vertex;
x = min(C(:,3));
% C  = [C;C];
N  = Cage.Normal;
V  = zeros(size(C));
E  = Cage.Edge;
% E  = [E;(1:c)' ((c+1):row(C))'];
l0 = distance(C(E(:,1),:),C(E(:,2),:));

C = 0.01*C;

n  = row(E);
m  = 1*ones(row(C),1);
ks = repmat(1.9,n,1);
kd = repmat(0.2,row(C),1);
dt = 0.01;

CreateViewer3D('Name','Undeformed',...
               'NumberTitle','off',...
               'MenuBar', 'none',...
               'ToolBar','none',...
               'right');
hM = Mesh.show();
hC = Cage.show('VertexNormals',Cage.Normal);

X = C(1:c,:);
i = 40;
% C(i,:) = C(i,:)+20.*N(i,:);


for frame = 1 : 1000
for i = 1 : 7
    [C,V] = deform(C,V,E,l0,ks,kd,m,dt);
    C((c+1):end,:) = X;
    V((c+1):end,:) = zeros(c,3);
end
hC.Vertices = C(1:c,:);
[p,n] = MVC_deformation(C(1:c,:),W,Mesh.Face);
hM.Vertices = p;
% hM.VertexNormals = n;
pause(0.1);
end

end


function [C,V] = deform(C,V,E,l0,ks,kd,m,dt)
Fd = damping_force(V,kd);
Fs = spring_force(C,E,l0,ks);
F  = Fd + Fs + [0 0 0];
[C,V] = integrate(C,V,F,dt,m);
end

function [X,V] = integrate(X,V,F,dt,m)
V = V + dt .* F ./ m;
X = X + dt .* V;
% P = X;
% X = X + dt .* V + dt .* dt .* F ./ m;
% V = V + ( X - P ) ./ dt;
end

function [F] = spring_force( C,E,l0,ks )
    d = C(E(:,1),:) - C(E(:,2),:);
    l = vecnorm3( d );
    x = l;
    x(x==0) = 1;
    F = ks .* ( d ./ x ) .* ( l - l0 );
    F = accumarray3([E(:,2);E(:,1)],[F;-F]);
end

function [F] = damping_force( V, kd )
    F = -kd .* V;
end

