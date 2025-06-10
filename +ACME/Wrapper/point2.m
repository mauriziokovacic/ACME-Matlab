function [h] = point2(P,varargin)
h=scatter(P(:,1),P(:,2),varargin{1:end});
end