function [Q,i] = stroke2vertex(Mesh,P)
i = Mesh.knn(P);
Q = Mesh.Vertex(i,:);
end