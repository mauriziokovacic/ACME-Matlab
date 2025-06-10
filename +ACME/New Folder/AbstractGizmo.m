classdef AbstractGizmo < handle
    properties
        Skeleton
        Target Editable
        Name(1,:) char = ''
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = AbstractGizmo(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Skeleton', [], @(data) isa(data,'Skeleton'));
            addParameter( parser, 'Target', [], @(data) isnumeric(data));
            addParameter( parser, 'Name',  '', @(data) isstring(data)||ischar(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        
    end
    
    methods( Access = public, Abstract )
        show(obj)
        apply(obj,delta)
    end
end



