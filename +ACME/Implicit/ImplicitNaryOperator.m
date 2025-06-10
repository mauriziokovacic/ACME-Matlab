classdef ImplicitNaryOperator < ImplicitOperator
    properties
        Primitive(:,1) AbstractImplicitSurface
    end
    
    methods(Access = public, Sealed = true)
        function [self] = ImplicitNaryOperator(varargin)
            self@ImplicitOperator(varargin{:});
        end
    end
end