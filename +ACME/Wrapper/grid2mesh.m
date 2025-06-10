function [P,T,varargout] = grid2mesh(G,varargin)
G = num2cell(G,[1 2]);
[T,P,C] = surf2patch(G{:},varargin{:});
if( ~isempty(C) && (nargout>=3) )
    varargout{1} = C;
end
end