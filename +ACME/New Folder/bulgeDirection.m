function [D] = bulgeDirection(S,P,N,W)
[Q,I] = project_on_bone(S,P);
Q = cell2mat(arrayfun(@(i) W(i,I)*Q{i},(1:row(P))','UniformOutput',false));
D = normr(N+normr(P-Q));
end