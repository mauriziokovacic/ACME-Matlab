classdef AbstractBrush < handle
    properties( Access = public, SetObservable )
        Radius
    end
    
    events
        RadiusChanged
    end
    
    methods( Access = public )
        function [obj] = AbstractBrush(varargin)
            parser = inputParser;
            addOptional( parser, 'Radius', 0, @(h) isscalar(h)&&(h>=0));
            parse(parser,varargin{:});
            obj.Radius = parser.Results.Radius;
            addlistener(obj,'Radius','PostSet',@(varargin) notify(obj,'RadiusChanged'));
        end
        
        function [obj] = setRadius(obj,radius)
            obj.set('Radius',radius);
        end
        
        function set(obj,propname,val)
            obj.(propname) = val;
        end
    end
    
    methods( Access = public, Abstract )
        [varargout] = eval(obj,varargin)
    end
end