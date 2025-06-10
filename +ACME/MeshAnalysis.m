clear all; clc;

% REST
[P, N, UV, T] = import_OBJ('Data/mesh_normal');
Rest = StaticMesh(P,N,UV,T);

% LBS
[P, N, UV, T] = import_OBJ('Data/mesh_normal');
LBS = StaticMesh(P,N,UV,T);

% DQS
[P, N, UV, T] = import_OBJ('Data/mesh_displaced');
DQS = StaticMesh(P,N,UV,T);

% CPS
% [P, N, UV, T] = import_OBJ('');
% CPS = StaticMesh(P,N,UV,T);

clear P N UV T;

D = mesh_cosine(LBS,DQS);

display_mesh(Rest.P, Rest.N, Rest.T, D );
