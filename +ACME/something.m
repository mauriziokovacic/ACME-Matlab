function [A] = something(P_,N_,T_,P)
Q = project_point_on_plane(P_,T_,P);
X = normr(cross(repmat(T_,row(P),1),Q-P_,2));
A = signed_angle(repmat(N_,row(P),1),X,repmat(T_,row(P),1));
end