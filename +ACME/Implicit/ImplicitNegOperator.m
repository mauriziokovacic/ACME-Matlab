classdef ImplicitNegOperator < ImplicitUnaryOperator
    methods(Access = public, Sealed = true)
        function [self] = ImplicitNegOperator(varargin)
            self@ImplicitUnaryOperator(varargin{:});
        end
    end
    
    methods(Access = protected)
        function [y, dx] = eval(~, y, dx)
            y  = -y;
            dx = -dx;
        end
    end
end