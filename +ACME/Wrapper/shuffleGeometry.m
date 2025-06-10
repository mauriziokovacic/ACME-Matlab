function [P,T,varargout] = shuffleGeometry(P,T,varargin)
I     = randperm(row(P));
[~,J] = sort(I,'ascend');
K     = randperm(row(T));
P     = P(I,:);
T(:)  = J(T);
T     = T(K,:);
if( nargin >= nargout )
    if( nargout >= 3 )
        for i = 1 : (nargout-2)
            if(row(varargin{i})==row(P))
                varargout{i} = varargin{i}(I,:);
            else
                if(row(varargin{i})==row(T))
                    varargout{i} = varargin{i}(K,:);
                end
            end
        end
    end
end
end

