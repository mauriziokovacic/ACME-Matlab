classdef ViewerTool < InteractiveFigure & SharedDataComponent
    properties
        LastPos
        AxesHandle
        ObjectHandle
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = ViewerTool(varargin)
            obj@InteractiveFigure('Name','Viewer Tool');
            obj@SharedDataComponent(varargin{:});
            obj.AxesHandle   = InteractiveAxes(obj.FigureHandle);
            obj.ObjectHandle = showObject(obj);
            updateFrustum(obj.AxesHandle);
            updateLight(obj.AxesHandle);
        end
    end
    
    methods( Access = public, Abstract )
        [h] = showObject(obj)
    end
    
    methods( Access = public )
        function EventMouseLeftClick(obj,~,event)
            obj.LastPos = event.Position;
        end
        
        function EventMouseLeftGrab(obj,~,event)
            p           = event.Position;
            dp          = obj.LastPos-p;
            obj.LastPos = p;
            rotateCamera(obj.AxesHandle,dp);
        end
        
        function EventMouseScroll(obj,~,event)
            s = 1-event.Data.VerticalScrollCount*0.1;
            zoomCamera(obj.AxesHandle,s);
        end
    end
    
    methods( Access = protected, Hidden = true )
        function CreateMenu(obj)
            menu = uimenu(obj.FigureHandle,'Text','Light');
            uimenu(menu,'Text','Off',      'MenuSelectedFcn',@(varargin) disableLight(obj.AxesHandle));
            uimenu(menu,'Text','Left',     'MenuSelectedFcn',@(varargin) cellfun(@(f) feval(f),{@() enableLight(obj.AxesHandle),@() setLightLeft(obj.AxesHandle)}));
            uimenu(menu,'Text','Headlight','MenuSelectedFcn',@(varargin) cellfun(@(f) feval(f),{@() enableLight(obj.AxesHandle),@() setLightHeadlight(obj.AxesHandle)}));
            uimenu(menu,'Text','Right',    'MenuSelectedFcn',@(varargin) cellfun(@(f) feval(f),{@() enableLight(obj.AxesHandle),@() setLightRight(obj.AxesHandle)}));
        end
    end
end