function [h]=line3(P,varargin)
h = line(P(:,1:3:end)',P(:,2:3:end)',P(:,3:3:end)',varargin{1:end});
end