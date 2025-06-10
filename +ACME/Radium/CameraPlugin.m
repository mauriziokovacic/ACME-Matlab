classdef CameraPlugin < AbstractInteractionPlugin
    properties
        Camera
    end
    
    methods
        function [obj] = CameraPlugin(varargin)
            obj@AbstractInteractionPlugin(varargin{:});
        end
        
        function [obj] = connectProgramData(obj,program)
            obj.Camera = CameraObject(program.AxesHandle);
        end
        
        function [obj] = EventMouseLeftGrab(obj,source,event)
            d = obj.Camera.ViewportDirection();
            obj.Camera.RotateCameraPosition(d(1),d(2));
        end
        
        function [obj] = EventMouseRightGrab(obj,source,event)
            d = obj.Camera.ViewportDirection();
            d = d*0.1;
            obj.Camera.RotateCameraTarget(d(1),d(2));
        end
        
        function [obj] = EventMouseWheelGrab(obj,source,event)
            d = obj.Camera.ViewportDirection();
            d = d*0.01;
            d = d(1) * -obj.Camera.CameraSide() +...
                d(2) *  obj.Camera.UpVector();
            obj.Camera.PanCamera(d(1),d(2),d(3));
        end
        
        function [obj] = EventMouseScroll(obj,source,event)
            scale = (1-event.Data.VerticalScrollCount*0.1);
            scale = (scale*obj.Camera.TargetDistance)./obj.Camera.TargetDistance;
            obj.Camera.ZoomCamera(scale);
        end
        
        function [obj] = EventKeyPress(obj,source,event)
            switch event.Key
                case 'c'
                    obj.Camera.CenterCamera();
                case 'x'
                    view(obj.Camera.Axes,90,0);
                case 'y'
                    view(obj.Camera.Axes,0,90);
                case 'z'
                    view(obj.Camera.Axes,0,0);
            end
        end
    end
end