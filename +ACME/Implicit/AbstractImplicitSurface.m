classdef AbstractImplicitSurface < handle
    methods(Access = public, Sealed = true)
        function [self] = AbstractImplicitSurface()
        end
    end
    
    methods(Abstract)
        [y, dx] = f(self, x)
    end
end