classdef InteractionEventHandler < handle
    properties( Access = public, SetObservable )
        Parent
        Type
        Enabled
    end
    
    properties( Access = private, Hidden = true )
        KeyListener
        KeyData
        MouseListener
        MouseData
    end
    
    events( ListenAccess = public )
        EventKeyboard
        
        EventKeyPress
        EventKeyRelease
    end
    
    events( ListenAccess = private, Hidden = true )
        EventMouse
        EventKey
    end
    
    methods( Access = public )
        function [obj] = InteractionEventHandler(varargin)
            parser = inputParser;
            addRequired( parser, 'Parent', @(h) isfigure(h) );
            parse(parser,varargin{:});
            obj.Parent = parser.Results.Parent;
            obj.connect();
            obj.resetData();
            obj.createListener();
            obj.toggleListener();
        end
        
        function Enable(obj)
            obj.Toggle(true);
        end
        
        function Disable(obj)
            obj.Toggle(false);
        end
        
        function Toggle(obj,status)
            obj.Enabled = status;
        end
        
        function [obj] = ThrowKeyEvent(obj,EventName,Modifier,Key)
            if(strcmpi(obj.Type,'none')||strcmpi(obj.Type,'mouse')||~obj.Enabled)
                return;
            end
            event = EventMouseData(obj.Parent,EventName,Modifier,Key);
            obj.dispatchKeyEvent(obj.Parent,event);
        end
        
        function ThrowMouseEvent(obj,EventName,Button,Modifier,Key,Position,Data)
            if(strcmpi(obj.Type,'none')||strcmpi(obj.Type,'keyboard')||~obj.Enabled)
                return;
            end
            event = EventMouseData(obj.Parent,EventName,Button,Modifier,Key,Position,Data);
            obj.dispatchMouseEvent(obj.Parent,event);
        end
    end
    
    methods( Access = private, Hidden = true )
        function createListener(obj)
            addlistener(obj,'Enabled','PostSet',@(varargin) obj.toggleListener(obj.Enabled));
            addlistener(obj,'Type','PostSet',@(varargin) obj.toggleListener(obj.Enabled));
            obj.KeyListener   = addlistener(obj,'EventKey',  @obj.dispatchKeyEvent);
            obj.MouseListener = addlistener(obj,'EventMouse',@obj.dispatchMouseEvent);
        end
        
        function toggleListener(obj, status)
            switch obj.Type
                case 'none'
                    obj.KeyListener.Enabled   = 'off';
                    obj.MouseListener.Enabled = 'off';
                case 'keyboard'
                    obj.KeyListener.Enabled   = status;
                    obj.MouseListener.Enabled = 'off';
                case 'mouse'
                    obj.KeyListener.Enabled   = 'off';
                    obj.MouseListener.Enabled = status;
                case 'all'
                    obj.KeyListener.Enabled   = status;
                    obj.MouseListener.Enabled = status;
            end
        end
        
        function connect(obj)
            obj.connectKeyboard();
            obj.connectMouse();
        end
        
        function disconnect(obj)
            obj.disconnectKeyboard();
            obj.disconnectMouse();
        end
        
        function connectMouse(obj)
            if(~isempty(obj.Parent))
                obj.Parent.WindowButtonDownFcn   = @obj.EventMouseInteraction;
                obj.Parent.WindowButtonUpFcn     = @obj.EventMouseInteraction;
                obj.Parent.WindowButtonMotionFcn = @obj.EventMouseInteraction;
                obj.Parent.WindowScrollWheelFcn  = @obj.EventMouseInteraction;
            end
        end
        
        function disconnectMouse(obj)
            if(~isempty(obj.Parent))
                obj.Parent.WindowButtonDownFcn   = [];
                obj.Parent.WindowButtonUpFcn     = [];
                obj.Parent.WindowButtonMotionFcn = [];
                obj.Parent.WindowScrollWheelFcn  = [];
            end
        end
        
        function connectKeyboard(obj)
            if(~isempty(obj.Parent))
                obj.Parent.WindowKeyPressFcn     = @obj.EventKeyInteraction;
                obj.Parent.WindowKeyReleaseFcn   = @obj.EventKeyInteraction;
            end
        end
        
        function disconnectKeyboard(obj)
            if(~isempty(obj.Parent))
                obj.Parent.WindowKeyPressFcn     = [];
                obj.Parent.WindowKeyReleaseFcn   = [];
            end
        end
        
        function resetData(obj)
            obj.resetKeyData();
            obj.resetMouseData();
        end
        
        function resetMouseData(obj)
            obj.MouseData = EventMouseData(obj.Parent,...
                                   [],...
                                   obj.Parent.SelectionType,...
                                   obj.KeyData.Modifier,...
                                   obj.KeyData.Key,...
                                   obj.Parent.CurrentPoint,...
                                   []);
        end
        
        function resetKeyData(obj)
            obj.KeyData = EventKeyData(obj.Parent,...
                                       [],...
                                       [],...
                                       []);
        end
        
        function EventMouseInteraction(obj,source,event)
            obj.resetMouseData();
            obj.MouseData.Event = event.EventName;
            if(strcmpi(event.EventName,'WindowScrollWheel'))
                obj.MouseData.Data.VerticalScrollCount  = event.VerticalScrollCount;
                obj.MouseData.Data.VerticalScrollAmount = event.VerticalScrollAmount;
            end
            notify(obj,'EventMouse',obj.MouseData);
        end
        
        function EventKeyInteraction(obj,source,event)
            obj.resetKeyData();
            obj.KeyData.Event    = strrep(event.EventName,'Window','');
            obj.KeyData.Modifier = event.Modifier;
            obj.KeyData.Key      = event.Key;
            notify(obj,'EventKey',obj.KeyData);
            if(strcmpi(obj.KeyData.Event,'KeyRelease'))
                obj.resetKeyData();
            end
        end
        
        function [obj] = dispatchKeyEvent(obj,source,event)
            notify(obj,'EventKeyboard',event);
            notify(obj,strcat('Event',event.Event),event);
        end
    end
    
end  