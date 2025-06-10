classdef InteractiveObject < handle
    methods( Access = public, Sealed = true )
        function [obj] = InteractiveObject(varargin)
        end
    end
    
    methods( Access = public )
        function EventKeyPress(obj,source,event)
        end
        
        function EventKeyRelease(obj,source,event)
        end
        
        function EventMouseClick(obj,source,event)
        end
        
        function EventMouseLeftClick(obj,source,event)
        end
        
        function EventMouseWheelClick(obj,source,event)
        end
        
        function EventMouseRightClick(obj,source,event)
        end
        
        function EventMouseDoubleClick(obj,source,event)
        end
        
        function EventMouseRelease(obj,source,event)
        end
        
        function EventMouseLeftRelease(obj,source,event)
        end
        
        function EventMouseWheelRelease(obj,source,event)
        end
        
        function EventMouseRightRelease(obj,source,event)
        end
        
        function EventMouseGrab(obj,source,event)
        end
        
        function EventMouseLeftGrab(obj,source,event)
        end
        
        function EventMouseWheelGrab(obj,source,event)
        end
        
        function EventMouseRightGrab(obj,source,event)
        end
        
        function EventMouseGrabRelease(obj,source,event)
        end
        
        function EventMouseLeftGrabRelease(obj,source,event)
        end
        
        function EventMouseWheelGrabRelease(obj,source,event)
        end
        
        function EventMouseRightGrabRelease(obj,source,event)
        end
        
        function EventMouseMove(obj,source,event)
        end
        
        function EventMouseScroll(obj,source,event)
        end
    end
end