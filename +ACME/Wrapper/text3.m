function [t] = text3(P,txt,varargin)
t = text(P(:,1),P(:,2),P(:,3),txt,varargin{1:end});
end