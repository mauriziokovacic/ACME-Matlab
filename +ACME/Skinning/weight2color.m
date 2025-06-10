function [CData] = weight2color(W,varargin)
CData = W * scatter_color(col(W),1:col(W),varargin{:});
end