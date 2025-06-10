function [X] = march(P,T,D)
I = T(:,1);
J = T(:,2);
K = T(:,3);
O = P([I;J;K],:);
N = triangle_normal(P,T);
N = [N;N;N];
D = D([I;J;K],:);
[~,D] = project_on_plane(O,N,O,D);
D = normr(D);
A = P([J;K;I],:);
B = P([K;I;J],:);
X = ray_segment_intersection(O,D,A,B);
end