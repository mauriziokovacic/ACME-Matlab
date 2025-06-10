function [A,t,L,k] = heat_diffusion_data(P,T,i,varargin)
A = barycentric_area(P,T);
% j = sub2ind(size(A),1:row(A),1:row(A));
% A(j) = 1./(2*A(j));
if( isempty(varargin) )
t = diffusion_time(1,mean_edge_length(P,T));
else
t = diffusion_mass(P,T,varargin{1});
end
[~,~,L] = differential_operator(P,T);
% L = cotangent_Laplacian(P,T);
k = Kronecker_delta(i,row(P));
end