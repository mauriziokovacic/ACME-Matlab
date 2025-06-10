classdef WeightBrush3D < WeightBrush
    properties
        Position = [0 0 0];
    end
    
    methods
        function [obj] = WeightBrush3D(varargin)
            obj@WeightBrush(varargin{:});
        end
    
        function [obj] = MoveBrush(obj,position)
            obj.Position = position;
        end
    end
end