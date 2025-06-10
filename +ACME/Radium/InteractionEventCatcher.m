classdef InteractionEventCatcher < handle
    properties( Access = public, SetObservable )
        Parent
    end
    
    properties( Access = private, Hidden = true )
        KeyData
        MouseData
    end
    
    events
        EventMouse
        EventKey
    end
    
    methods
        function [obj] = InteractionEventCatcher(parent)
            obj.Parent = parent;
            obj.resetKeyData();
            obj.resetMouseData();
            obj.CreateEventConnections();
        end
    end
    
    methods( Access = private, Hidden = true )
        function [obj] = EventMouseInteraction(obj,source,event)
            obj.resetMouseData();
            obj.MouseData.Event = event.EventName;
            if(strcmpi(event.EventName,'WindowScrollWheel'))
                obj.MouseData.Data.VerticalScrollCount  = event.VerticalScrollCount;
                obj.MouseData.Data.VerticalScrollAmount = event.VerticalScrollAmount;
            end
            notify(obj,'EventMouse',obj.MouseData);
        end
        
        function [obj] = EventKeyInteraction(obj,source,event)
            obj.resetKeyData();
            obj.KeyData.Event    = strrep(event.EventName,'Window','');
            obj.KeyData.Modifier = event.Modifier;
            obj.KeyData.Key      = event.Key;
            notify(obj,'EventKey',obj.KeyData);
            if(strcmpi(obj.KeyData.Event,'KeyRelease'))
                obj.resetKeyData();
            end
        end
        
        function [obj] = CreateEventConnections(obj,varargin)
            obj.Parent.WindowButtonDownFcn   = @obj.EventMouseInteraction;
            obj.Parent.WindowButtonUpFcn     = @obj.EventMouseInteraction;
            obj.Parent.WindowButtonMotionFcn = @obj.EventMouseInteraction;
            obj.Parent.WindowScrollWheelFcn  = @obj.EventMouseInteraction;
            obj.Parent.WindowKeyPressFcn     = @obj.EventKeyInteraction;
            obj.Parent.WindowKeyReleaseFcn   = @obj.EventKeyInteraction;
        end
        
        function [obj] = resetMouseData(obj)
            obj.MouseData = EventMouseData(obj.Parent,...
                                   [],...
                                   obj.Parent.SelectionType,...
                                   obj.KeyData.Modifier,...
                                   obj.KeyData.Key,...
                                   obj.Parent.CurrentPoint,...
                                   []);
        end
        
        function [obj] = resetKeyData(obj)
            obj.KeyData = EventKeyData(obj.Parent,...
                                       [],...
                                       [],...
                                       []);
        end
    end
end