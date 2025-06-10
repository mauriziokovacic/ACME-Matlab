classdef InteractiveAxes < InteractiveObject
    properties( Access = public, SetObservable )
        Light
        LightPosition
        AxesHandle
    end
    
    methods( Access = public )
        function [obj] = InteractiveAxes(varargin)
            obj@InteractiveObject();
            parser = inputParser;
            parser.KeepUnmatched = true;
            addRequired( parser, 'Figure', @(data) isfigure(data));
            addParameter( parser, 'LightPosition', 'right', @(data) isstring(data)||ischar(data));
            parse(parser,varargin{:});
            fig               = parser.Results.Figure;
            obj.AxesHandle    = CreateAxes3D(fig);
            obj.LightPosition = parser.Results.LightPosition;
            obj.Light         = camlight(obj.AxesHandle,obj.LightPosition);
            
            addlistener(obj.AxesHandle,'Projection',      'PostSet', @(varargin) updateLight(obj));
            addlistener(obj.AxesHandle,'CameraPosition',  'PostSet', @(varargin) updateLight(obj));
            addlistener(obj.AxesHandle,'CameraTarget',    'PostSet', @(varargin) updateLight(obj));
            addlistener(obj.AxesHandle,'CameraUpVector',  'PostSet', @(varargin) updateLight(obj));
            addlistener(obj.AxesHandle,'CameraViewAngle', 'PostSet', @(varargin) updateLight(obj));
            addlistener(obj,'LightPosition', 'PostSet', @(varargin) updateLight(obj));
        end
        
        function toggleLight(obj,status)
            obj.Light.Visible = status;
        end
        
        function enableLight(obj)
            toggleLight(obj,true);
        end
        
        function disableLight(obj)
            toggleLight(obj,false);
        end
        
        function setLightPosition(obj,position)
            obj.LightPosition = position;
        end
        
        function setLightLeft(obj)
            setLightPosition(obj,'left');
        end
        
        function setLightHeadlight(obj)
            setLightPosition(obj,'headlight');
        end
        
        function setLightRight(obj)
            setLightPosition(obj,'right');
        end
        
        function updateLight(obj)
            camlight(obj.Light,obj.LightPosition);
        end
        
        function updateFrustum(obj)
            set(obj.AxesHandle,...
                'XLimMode','auto',...
                'YLimMode','auto',...
                'ZLimMode','auto');
            cubeFrustum(obj.AxesHandle);
        end
        
        function rotateCamera(obj,factor)
            arrayfun(@(ax) camorbit(ax,factor(1),factor(2),'coordsys','camera'),obj.AxesHandle);
        end
        
        function zoomCamera(obj,factor)
            if( factor <= 0 )
                return;
            end
            arrayfun(@(ax) camzoom(ax,factor), obj.AxesHandle);
        end
    end
end