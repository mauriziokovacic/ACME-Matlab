classdef TimeSignalFcn < handle
    properties( Access = public, SetObservable )
        Period
    end
    
    properties( Access = private, Hidden = true )
        Fcn
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = TimeSignalFcn(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Period', 1, @(data) isscalar(data));
            addParameter( parser, 'Data',  [], @(data) isnumeric(data));
            parse(parser,varargin{:});
            obj.Period = parser.Results.Period;
            Data       = parser.Results.Data;
            if(~isempty(Data))
                if(~isvector(Data))
                    error('Data should be a vector');
                else
                    updateData(obj,Data);
                end
            end
        end
        
        function [tf] = isReady(obj)
            tf = ~isempty(getData(obj));
        end
        
        function [out] = getData(obj)
            out = [];
            if(~isempty(obj.Fcn))
                out = obj.Fcn.Values;
            end
        end
        
        function updateData(obj,Data)
            if(~isvector(Data))
                error('Data should be a vector');
            end
            updateFcn(obj,Data);
        end
        
        function [b] = fetch(obj,t)
            b = obj.Fcn(normalizeTime(obj,t));
        end
    end
    
    methods( Access = private, Hidden = true )
        function updateFcn(obj,Data)
            [X]     = linspace(0,1,numel(Data));
            obj.Fcn = griddedInterpolant(X,Data,'pchip','nearest');
        end
        
        function [t] = normalizeTime(obj,t)
            t = mod(t,obj.Period)./obj.Period;
        end
    end
end