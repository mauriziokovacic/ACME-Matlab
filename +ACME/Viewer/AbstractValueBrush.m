classdef AbstractValueBrush < AbstractBrush
    properties( Access = public, SetObservable )
        Value
        Strenght
    end
    
    events
        ValueChanged
        StrenghtChanged
    end
    
    methods( Access = public )
        function [obj] = AbstractValueBrush(varargin)
            obj@AbstractBrush(varargin{:});
            parser = inputParser;
            addOptional( parser, 'Value', [],  @(h) isnumeric(h));
            addOptional( parser, 'Strenght', @(h) isscalar(h)&&(h>=0)&&(h<=1));
            parse(parser,varargin{2:end});
            obj.Value    = parser.Results.Value;
            obj.Strenght = parser.Results.Strenght;
            addlistener(obj,'Value','PostSet',@(varargin) notify(obj,'ValueChanged'));
            addlistener(obj,'Strenght','PostSet',@(varargin) notify(obj,'StrenghtChanged'));
        end
        
        function [obj] = setValue(obj,value)
            obj.set('Value',value);
        end
        
        function [obj] = setStrenght(obj,strenght)
            obj.set('Strenght',clamp(strenght,0,1));
        end
    end
end