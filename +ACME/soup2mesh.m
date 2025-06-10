function [P,T,I,J] = soup2mesh(P,T)
[P,I,J] = uniquetol(P,0.0001,'ByRows',true);
T(:)    = J(T);
if(istri(T))
    T(arrayfun(@(i) numel(unique(T(i,:)))~=col(T),(1:row(T))'),:) = [];
end
end

% function [P,T,varargout] = soup2mesh(P,T,varargin)
% n       = row(P);
% [P,I,J] = uniquetol(P,0.0001,'ByRows',true);
% T(:)    = J(T);
% if(istri(T))
% T(arrayfun(@(i) numel(unique(T(i,:)))~=col(T),(1:row(T))'),:) = [];
% end
% if( nargin >= nargout )
%     if( nargout >= 3 )
%         for i = 1 : (nargout-2)
%             if( row(varargin{i})==n )
%                 varargout{i} = varargin{i}(I,:);
%             else
%                 varargout{i}(:) = J(varargin{i});
%             end
%         end
%     end
% end
% % A = triangle_area(P,T);
% % T(A==0,:)  = [];
% end