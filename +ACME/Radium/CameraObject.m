classdef CameraObject < handle
    properties( Access = public,...
                SetObservable )
        CurrentViewport
        PreviousViewport
        Axes
    end
    
    events
        CameraChanged
        CameraProjectionChanged
        CameraPositionChanged
        CameraTargetChanged
        CameraUpVectorChanged
        CameraDirectionChanged
        CameraViewAngleChanged
    end
    
    methods( Access = public )
        function [obj] = CameraObject(ax,varargin)
            obj.Axes = ax;
            fig      = ancestor(ax,'figure');
            
            addlistener(fig,'CurrentPoint','PreSet',  @(varargin) obj.setPreviousViewport(fig.CurrentPoint));
            addlistener(fig,'CurrentPoint','PostSet', @(varargin) obj.setCurrentViewport(fig.CurrentPoint));
            
            addlistener(ax,'Projection',      'PostSet', @(varargin) notify(obj,'CameraProjectionChanged'));
            addlistener(ax,'CameraPosition',  'PostSet', @(varargin) notify(obj,'CameraPositionChanged'));
            addlistener(ax,'CameraTarget',    'PostSet', @(varargin) notify(obj,'CameraTargetChanged'));
            addlistener(ax,'CameraUpVector',  'PostSet', @(varargin) notify(obj,'CameraUpVectorChanged'));
            addlistener(ax,'CameraViewAngle', 'PostSet', @(varargin) notify(obj,'CameraViewAngleChanged'));

            addlistener(obj,'CameraPositionChanged',  @(varargin) notify(obj,'CameraDirectionChanged'));
            addlistener(obj,'CameraTargetChanged',    @(varargin) notify(obj,'CameraDirectionChanged'));
            addlistener(obj,'CameraProjectionChanged',@(varargin) notify(obj,'CameraChanged'));
            addlistener(obj,'CameraPositionChanged',  @(varargin) notify(obj,'CameraChanged'));
            addlistener(obj,'CameraTargetChanged',    @(varargin) notify(obj,'CameraChanged'));
            addlistener(obj,'CameraUpVectorChanged',  @(varargin) notify(obj,'CameraChanged'));
            addlistener(obj,'CameraDirectionChanged', @(varargin) notify(obj,'CameraChanged'));
            addlistener(obj,'CameraViewAngleChanged', @(varargin) notify(obj,'CameraChanged'));
        end
        
        function [out] = Projection(obj)
            out = obj.Axes.Projection;
        end
        
        function setProjection(obj,in)
            obj.Axes.Projection = in;
        end
        
        function [out] = Position(obj)
            out = obj.Axes.CameraPosition;
        end
        
        function setPosition(obj,in)
            obj.Axes.CameraPosition = in;
        end
        
        function [out] = Target(obj)
            out = obj.Axes.CameraTarget;
        end
        
        function setTarget(obj,in)
            obj.Axes.CameraTarget = in;
        end
        
        function [out] = UpVector(obj)
            out = obj.Axes.CameraUpVector;
        end
        
        function setUpVector(obj,in)
            obj.Axes.CameraUpVector = in;
        end
        
        function [out] = Direction(obj)
            out = normr(obj.Target()-obj.Position());
        end
        
        function setDirection(obj,in)
            d = norm(obj.Target()-obj.Position());
            obj.setTarget(obj.Position()+d*in);
        end
        
        function [D] = CameraSide(obj)
            D = cross(obj.UpVector(),obj.Direction(),2);
        end
        
        function [D] = TargetDistance(obj)
            D = norm(obj.Target()-obj.Position());
        end
        
        function [out] = ViewAngle(obj)
            out = obj.Axes.CameraViewAngle;
        end
        
        function setViewAngle(obj,in)
            obj.Axes.CameraViewAngle = in;
        end
        
        function [D] = ViewportDirection(obj)
            D = obj.PreviousViewport-obj.CurrentViewport;
        end
        
        function [obj] = RotateCameraPosition(obj,dtheta,dphi)
            camorbit(obj.Axes,dtheta,dphi,'coordsys','camera');
        end
        
        function [obj] = RotateCameraTarget(obj,dtheta,dphi)
            campan(obj.Axes,dtheta,dphi,'coordsys','camera');
        end
        
        function [obj] = PanCamera(obj,dx,dy,dz)
            camdolly(obj.Axes,dx,dy,dz);
        end
        
        function [obj] = ZoomCamera(obj,scale)
            camzoom(obj.Axes,scale);
        end
        
        function [obj] = CenterCamera(obj)
            view(obj.Axes,2);
        end
    end
    
    methods( Access = private, Hidden = true )
        function setCurrentViewport(obj,in)
            obj.CurrentViewport = in;
        end
        
        function setPreviousViewport(obj,in)
            obj.PreviousViewport = in;
        end
    end
end