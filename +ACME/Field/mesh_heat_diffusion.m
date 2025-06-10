function [u] = mesh_heat_diffusion(P,T,i,varargin)
[A,t,L,k] = heat_diffusion_data(P,T,i,varargin{1:end});
u = heat_diffusion(A,t,L,k);
end