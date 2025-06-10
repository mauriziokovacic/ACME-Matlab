classdef AbstractTransform < handle
    properties( Access = public, SetObservable )
        Data
        Delta
        Constraint
        DefaultDelta
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = AbstractTransform(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Data',              zeros(1,3), @(data) isnumeric(data));
            addParameter( parser, 'Delta',             zeros(1,3), @(data) isnumeric(data));
            addParameter( parser, 'Constraint',  [-1;1].*Inf(2,3), @(data) isnumeric(data));
            addParameter( parser, 'DefaultDelta',      zeros(1,3), @(data) isnumeric(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
            
            addListener(obj,'Delta',       'PostSet',@(o,e) applyConstraint(o));
            addListener(obj,'Constrint',   'PostSet',@(o,e) applyConstraint(o));
            addListener(obj,'DefaultDelta','PostSet',@(o,e) applyConstraint(o));
        end
        
        function applyDelta(obj)
            obj.Data  = obj.Data + obj.Delta;
            obj.Delta = obj.DefaultDelta;
        end
        
        function applyConstraint(obj)
            obj.Delta        = clamp(obj.Delta,       obj.Constraint(1,:),obj.Constraint(2,:));
            obj.DefaultDelta = clamp(obj.DefaultDelta,obj.Constraint(1,:),obj.Constraint(2,:));
        end
    end
    
    methods( Access = public )
        function [X] = transform2original(obj)
            X = convertData(obj.Data);
        end
        
        function [X] = transform2modified(obj)
            X = convertData(obj.Data+obj.Delta);
        end
    end
    
    methods( Access = protected, Static )
        function [X] = convertData(data)
            X = [];
        end
    end
end