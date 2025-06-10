classdef ImplicitGradientBasedOperator < ImplicitBinaryOperator
    properties
        Grid
    end
    
    methods(Access = public, Sealed = true)
        function [self] = ImplicitGradientBasedOperator(varargin)
            self@ImplicitBinaryOperator(varargin{:});
        end
    end
    
    methods(Access = protected)
        function [y, dx] = eval(self, y, dx)
            theta = vecangle(dx(:,:,1), dx(:,:,2));
            [y, beta] = self.Grid.fetch(y(:,1), y(:,2), theta);
            dx = beta .* dx(:,:,1) + (1-beta) .* dx(:,:,2);
        end
    end
end