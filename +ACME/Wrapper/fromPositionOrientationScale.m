function [M] = fromPositionOrientationScale(T,R,S)
M = R*S;
M(:,4) = T(:,4);
end