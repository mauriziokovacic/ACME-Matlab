function [D] = fold_distance(P, C, W)
D = distance(P,C.getOrderedPoint(),2).*sign(W(:,C.Handle)-0.5);
end