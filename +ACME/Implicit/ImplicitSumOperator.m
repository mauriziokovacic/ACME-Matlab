classdef ImplicitSumOperator < ImplicitNaryOperator
    methods(Access = public, Sealed = true)
        function [self] = ImplicitSumOperator(varargin)
            self@ImplicitNaryOperator(varargin{:});
        end
    end
    
    methods(Access = protected)
        function [y, dx] = eval(~, y, dx)
            y  = sum(y, 2);
            dx = sum(dx,3);
        end
    end
end