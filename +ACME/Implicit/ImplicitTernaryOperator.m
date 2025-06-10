classdef ImplicitTernaryOperator < ImplicitOperator
    properties
        Primitive(3,1) AbstractImplicitSurface
    end
    
    methods(Access = public, Sealed = true)
        function [self] = ImplicitTernaryOperator(varargin)
            self@ImplicitOperator(varargin{:});
        end
    end
end