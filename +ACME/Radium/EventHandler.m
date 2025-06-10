classdef EventHandler < handle
    properties( Access = private, Hidden = true )
        Parent
        Listener
    end
    
    methods( Access = public )
        function [obj] = EventHandler(interaction_handler,eventName)
            obj.Parent   = interaction_handler;
            obj.Listener = addlistener(interaction_handler,eventName,@obj.dispatchEvent);
        end
        
        function delete(obj)
            delete(obj.Listener);
        end
        
        function Enable(obj)
            obj.Toggle(true);
        end
        
        function Disable(obj)
            obj.Toggle(false);
        end
        
        function Toggle(obj,status)
            obj.Listener.Enabled = status;
        end
        
        function [tf] = isEnabled(obj)
            tf = obj.Listener.Enabled;
        end
        
        function [tf] = isDisabled(obj)
            tf = ~obj.Listener.Enabled;
        end
        
        function [h] = getFigure(obj)
            h = obj.Parent.Parent;
        end
    end
    
    methods( Access = protected, Abstract )
        [obj] = dispatchEvent(obj,source,event)
    end
end