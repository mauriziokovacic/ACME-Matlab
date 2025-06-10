function [t] = text2(P,txt,varargin)
t = text(P(:,1),P(:,2),txt,varargin{1:end});
end