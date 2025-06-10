classdef Editable < handle
    properties( Access = public, SetObservable )
        Data
        Delta
        Constraint
    end
    
    events
        DataChanged
        DeltaChanged
        ConstraintChanged
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = Editable(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Data',             zeros(1,3), @(data) isvector(data));
            addParameter( parser, 'Delta',            zeros(1,3), @(data) isvector(data));
            addParameter( parser, 'Constraint', [-1;1].*Inf(2,3), @(data) all(size(data)==[2 3]));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
            addlistener(obj,'Delta',     'PostSet',@obj.applyConstraint);
            addlistener(obj,'Constraint','PostSet',@obj.applyConstraint);
%             addlistener(obj,'Data',      'PostSet', @(varargin) notify(obj,'DataChanged'));
%             addlistener(obj,'Delta',     'PostSet', @(varargin) notify(obj,'DeltaChanged'));
%             addlistener(obj,'Constraint','PostSet', @(varargin) notify(obj,'ConstraintChanged'));
        end
        
        function [d] = referenceData(obj)
            d = obj.Data;
        end
        
        function [d] = currentData(obj)
            d = obj.Data + obj.Delta;
        end
        
        function applyDelta(obj)
            obj.Data = currentData(obj);
            resetDelta(obj);
        end
    end
    
    methods( Access = public )
        function resetDelta(obj)
            obj.Delta = [0 0 0];
        end
    end
    
    methods( Access = private, Hidden = true )
        function applyConstraint(obj,varargin)
            if(any(obj.Delta<obj.Constraint(1,:))||...
               any(obj.Delta>obj.Constraint(2,:)))
                obj.Delta = clamp(obj.Delta,...
                                  obj.Constraint(1,:),...
                                  obj.Constraint(2,:));
            end
        end
    end
end