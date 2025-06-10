classdef WeightBrush < BrushBase
    properties
        Inverted
    end
    
    methods
        function [obj] = WeightBrush(varargin)
            obj@BrushBase(varargin{:});
            obj.Inverted = false;
        end
        
        function [obj] = invert(obj)
            obj.Inverted = ~obj.Inverted;
        end
        
        function [obj] = toggleInverted(obj,status)
            obj.Inverted = status;
        end
    end
    
    methods( Access = protected )
        function [Value] = BrushFunction(obj,Distance,Value)
            X = obj.Strenght .* obj.Value;
            if( obj.Inverted )
                X = -X;
            end
            Value = (1-Distance) .* Value + Distance .* (Value + X);
            Value = clamp(Value,0,1);
        end
    end
end