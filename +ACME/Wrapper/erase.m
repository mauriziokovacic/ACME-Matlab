function [V] = erase(V,index,dim)
if(nargin<3)
    dim = 2;
end
switch dim
    case 1
        V(:,index) = [];
    case 2
        V(index,:) = [];
    otherwise
        V(index) = [];
end
end