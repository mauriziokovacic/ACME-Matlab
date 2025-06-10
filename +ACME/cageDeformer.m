function [P,N] = cageDeformer(C,U,T,W,t,N)
C = C + t;
P = W * C;
V = vertex_normal(C,T);
R = mat2lin(arrayfun(@(i) rotation(U(i,:),V(i,:)),(1:row(C))','UniformOutput',false));
R = compute_transform(R,W);
N = transform_normal(R,N,'mat');
end

function [R] = rotation(U,V)
R = [axang2rotm([normr(cross(U,V,2)) angle(U,V)]) zeros(3,1); zeros(1,3) 1];
end