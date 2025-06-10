function [P,T,varargout] = mesh2soup(P,T,varargin)
n = col(T);
v = reshape(T',numel(T),1);
P = P(v,:);
T = reshape((1:row(P))',n,numel(v)/n)';
if( nargin >= nargout )
    if( nargout >= 3 )
        for i = 1 : (nargout-2)
            varargout{i} = varargin{i}(v,:);
        end
    end
end
end