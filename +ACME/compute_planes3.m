n = from_barycentric(N,T,ID(E(:,2)),B(E(:,2),:));
N_ = normr(P-P_);
N_ = specular_direction(n,N_);
N_ = align_direction(N_,Adjacency(P,T,'cot'),5);
N_ = reorient_plane(P_,N_,P);
clear n;