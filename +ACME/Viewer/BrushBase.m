classdef BrushBase < AbstractValueBrush
    methods
        function [obj] = BrushBase(varargin)
            obj@AbstractValueBrush();
        end
        
        function [Value] = eval(obj,Position,Point,Value)
            if( isempty(Point) || isempty(obj.Value) || ( obj.Radius <= 0 ) )
                return;
            end
            Distance = obj.BrushDistance(Position,Point);
            i = find(Distance);
            Value(i,:) = obj.BrushFunction(Distance(i),Value(i,:));
        end
    end
    
    methods( Access = private, Hidden = true )
        function [Distance] = BrushDistance(obj,Position,Point)
                Distance = 1-( clamp( vecnorm(Point-Position,2,2),...
                                      0,...
                                      obj.Radius ) ...
                               / obj.Radius );
        end
    end
    
    methods( Abstract, Access = protected )
        [Value] = BrushFunction(obj,Distance,Value)
    end
end