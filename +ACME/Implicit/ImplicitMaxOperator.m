classdef ImplicitMaxOperator < ImplicitNaryOperator
    methods(Access = public, Sealed = true)
        function [self] = ImplicitMaxOperator(varargin)
            self@ImplicitNaryOperator(varargin{:});
        end
    end
    
    methods(Access = protected)
        function [y, dx] = eval(~, y, dx)
            [y, i] = max(y, [], 2);
            dx = dx(:,:,i);
        end
    end
end