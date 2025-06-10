function [h] = display_skeleton(P,D,varargin)
h = line3([P P+D],varargin{1:end});
end