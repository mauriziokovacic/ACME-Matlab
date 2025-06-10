function [F] = fold_skeleton_weight(S,W)
i = cell(S.nJoint(), 1);
for s = 1 : S.nJoint()
    i{s} = subtree(S.Graph, s);
end
F = sparse(row(W), row(i));
for w = 1 : row(i)
    F(:,w) = sum(W(:,i{w}),2);
end
end