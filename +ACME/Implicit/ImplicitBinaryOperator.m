classdef ImplicitBinaryOperator < ImplicitOperator
    properties
        Primitive(2,1) AbstractImplicitSurface
    end
    
    methods(Access = public, Sealed = true)
        function [self] = ImplicitBinaryOperator(varargin)
            self@ImplicitOperator(varargin{:});
        end
    end
end