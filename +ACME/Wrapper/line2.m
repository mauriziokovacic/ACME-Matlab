function [h]=line2(P,varargin)
h = line(P(:,1:2:end)',P(:,2:2:end)',varargin{1:end});
end