function [im] = mat2img(M,varargin)
im = imagesc(M,varargin{:});
end