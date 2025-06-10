function [F] = distanceField(Mesh,Res)
if(nargin<2)
    Res = 64;
end
P = Mesh.Vertex;
T = Mesh.Face;

O = triangle_barycenter(P,T);
N = triangle_normal(P,T);

[xMin,yMin,zMin] = tri2ind(min(P));
[xMax,yMax,zMax] = tri2ind(max(P));

[X,Y,Z] = meshgrid(linspace(xMin,xMax,Res),...
                   linspace(yMin,yMax,Res),...
                   linspace(zMin,zMax,Res));
F = zeros(size(X));
F(1:end) = arrayfun(@(i) min(distance([X(i) Y(i) Z(i)],O)),(1:Res^3));

CreateViewer3D('right');
Mesh.show();
hold on;
isosurface(X,Y,Z,F,0.1);
end