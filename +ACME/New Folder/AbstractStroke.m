classdef AbstractStroke < handle
    properties( Access = public, SetObservable )
        Point
        Pressure
        Strength
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = AbstractStroke(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Point',    [], @(data) isnumeric(data));
            addParameter( parser, 'Pressure', [], @(data) isnumeric(data));
            addParameter( parser, 'Strength', [], @(data) isscalar(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function setHardPressure(obj)
            setPressure(obj,ones(row(obj.Point),1));
        end
        
        function setNullPressure(obj)
            setPressure(obj,zeros(row(obj.Point),1));
        end
        
        function setSoftPressure(obj,strength)
            if(nargin<2)
                strength = 1;
            end
            strength = clamp(strength,0.001,1);
            t = curve2param(getPoint(obj));
            x = normalize(gaussmf(t,[strength, 0.5]));
            x(abs(x)<0.001) = 0;
            setPressure(obj,x);
        end
        
        function setPressure(obj,U)
            obj.Pressure = U;
        end
        
        function insertPoint(obj,P)
            obj.Point = [obj.Point;P];
        end
    end
    
    methods( Access = public )
        function [P] = getPoint(obj)
            P = obj.Point;
        end
    end
end


