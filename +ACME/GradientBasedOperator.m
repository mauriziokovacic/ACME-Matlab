classdef GradientBasedOperator < handle
    properties( Access = private, Hidden = true )
        F
        dFi
        dFj
    end
    
    properties( Access = public )
        Alpha
        Beta
    end
    
    methods( Access = public )
        function [obj] = GradientBasedOperator(V)
            [X,Y,Z] = ndgrid(linspace(0,1,128));
            obj.F   = griddedInterpolant(X,Y,Z,V);
            obj.dFi = griddedInterpolant(X,Y,Z,V);
            obj.dFj = griddedInterpolant(X,Y,Z,V);
        end
        
        function [varargout] = fetch(obj,fi,fj,theta)
            if nargout == 0
                return;
            end
            if nargout >= 1
                varargout{1} = obj.F(fi,fj,theta);
            end
            if nargout >= 2
                beta    = zeros(1,2);
                beta(1) = obj.dFi(fi,fj,theta);
                beta(2) = obj.dFj(fi,fj,theta);
                varargout{2} = beta;
            end
        end
    end
end