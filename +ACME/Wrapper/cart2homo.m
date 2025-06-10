function [H] = cart2homo(C,w)
if(nargin<2)
    w = 1;
end
H = [C, repmat(w,row(C),1)];
end