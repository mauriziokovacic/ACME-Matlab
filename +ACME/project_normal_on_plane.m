function [X] = project_normal_on_plane(P,N,Q)
[~,X] = project_on_plane(P,N,P,Q);
end