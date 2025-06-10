classdef SharedDataComponent < handle
    properties( Access = public, SetObservable )
        Parent
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = SharedDataComponent(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addRequired( parser, 'Parent', @(data) isa(data,'SharedDataSystem'));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
            registerChild(obj.Parent,obj);
            registerProps(obj);
        end
    end
    
    methods( Access = protected )
        function addProps(obj,propName)
            addProps(obj.Parent,propName);
        end
        
        function [value] = getProps(obj,propName)
            value = getProps(obj.Parent,propName);
        end
        
        function setProps(obj,propName,propValue)
            setProps(obj.Parent,propName,propValue);
        end
        
        function [h] = addPropListener(obj,propName,valueChangeFcn)
            h = addPropListener(obj.Parent,propName,valueChangeFcn);
        end
    end
    
    methods( Access = public, Abstract )
        registerProps(obj)
    end
end