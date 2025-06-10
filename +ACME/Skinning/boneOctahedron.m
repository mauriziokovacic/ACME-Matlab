function [P,N,T] = boneOctahedron(length,frame)
P = [0 0 0; 0.25 0 0.25; 0 0.25 0.25; -0.25 0 0.25; 0 -0.25 0.25; 0 0 1];
P = P.*[repmat(length/2,1,2) length];
T = [1 2 3; 1 3 4; 1 4 5; 1 5 2; 6 3 2; 6 4 3; 6 5 4; 6 2 5];
f = @(d) d(1:end-1);
P = cell2mat(cellfun(@(p) f((frame * [p 1]')'),num2cell(P,2),'UniformOutput',false));
N = vertex_normal(P,T);
end