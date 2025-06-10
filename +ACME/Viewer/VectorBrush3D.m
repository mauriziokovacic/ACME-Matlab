classdef VectorBrush3D < VectorBrush
    properties
        Position = [0 0 0];
    end
    
    methods
        function [obj] = VectorBrush3D(varargin)
            obj@VectorBrush(varargin{:});
        end
        
        function [obj] = MoveBrush(obj,position)
            obj.Position = position;
        end
    end
end