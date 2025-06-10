function [h] = point3(P,varargin)
h = [];
if(isempty(P))
    return;
end
h = scatter3(P(:,1),P(:,2),P(:,3),varargin{1:end});
end