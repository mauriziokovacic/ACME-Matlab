classdef TextureCell
properties
    UV
    Data
end

methods
    function [obj] = TextureCell(varargin)
        if( nargin >= 1 )
            obj.UV = varargin{1};
        else
            obj.UV = [0 0;0 1;1 0;1 1];
        end
        if( nargin >= 2 )
            obj.Data = varargin{2};
        else
            obj.Data   = [0 0 0 0];
        end
    end
    
    function [tf] = valid(obj)
        tf = vecnorm(obj.min_uv()-obj.max_uv(),2,2)>0.0001;
    end
    
    function [D] = fetch(obj,uv)
        s   = obj.size_uv();
        dx0 = ( uv - obj.min_uv() ) ./ s;
        dx1 = ( obj.max_uv() - uv ) ./ s;
        w   = [dx1;...
               dx1(:,1) dx0(:,2);...
               dx0(:,1) dx1(:,2);...
               dx0]; 
        D = sum( prod(w,2) .* obj.Data );
    end
end
    
methods( Access = private )
    function [uv] = min_uv(obj)
        uv = obj.UV(1,:);
    end
    
    function [uv] = max_uv(obj)
        uv = obj.UV(4,:);
    end
    
    function [d] = size_uv(obj)
        d = obj.max_uv()-obj.min_uv();
    end
end
end