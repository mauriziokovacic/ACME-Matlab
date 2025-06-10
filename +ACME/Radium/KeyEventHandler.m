classdef KeyEventHandler < EventHandler
    events
        EventKeyPress
        EventKeyRelease
    end
    
    methods( Access = public )
        function [obj] = KeyEventHandler(interaction_handler)
            obj@EventHandler(interaction_handler,'EventKey');
        end
        
        function [obj] = ThrowKeyEvent(obj,EventName,Modifier,Key)
            event = EventMouseData(obj.Parent,EventName,Modifier,Key);
            obj.dispatchEvent(obj.Parent,event);
        end
    end
    
    methods( Access = protected, Hidden = true )
        function [obj] = dispatchEvent(obj,source,event)
            notify(obj,strcat('Event',event.Event),event);
        end
    end
end