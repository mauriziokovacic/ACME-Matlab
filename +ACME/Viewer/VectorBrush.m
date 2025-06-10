classdef VectorBrush < BrushBase
    methods
        function [obj] = VectorBrush(varargin)
            obj@BrushBase(varargin{:});
        end
    end
    
    methods( Access = protected )
        function [Value] = BrushFunction(obj,Distance,Value)
            Value = (1-obj.Strenght) .* Value + obj.Strenght .* (obj.Value);
        end
    end
end