classdef ImplicitUnaryOperator < ImplicitOperator
    properties
        Primitive(1,1) AbstractImplicitSurface
    end
    
    methods(Access = public, Sealed = true)
        function [self] = ImplicitUnaryOperator(varargin)
            self@ImplicitOperator(varargin{:});
        end
    end
end