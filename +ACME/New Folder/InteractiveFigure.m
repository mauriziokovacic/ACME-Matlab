classdef InteractiveFigure < InteractiveObject
    properties
        FigureHandle matlab.ui.Figure
    end
    
    properties( Access = private, Hidden = true )
        InterCatcher
        KeyHandler
        MouseHandler
        ConsoleText
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = InteractiveFigure(varargin)
            obj.FigureHandle = figure('Name','Interactive Figure',...
                                      'NumberTitle','off',...
                                      'MenuBar', 'none',...
                                      ...'ToolBar','none',...
                                      'Units','pixels',...
                                      varargin{:});
            obj.InterCatcher = InteractionEventCatcher(obj.FigureHandle);
            obj.KeyHandler   = KeyEventHandler(obj.InterCatcher);
            obj.MouseHandler = MouseEventHandler(obj.InterCatcher);
            obj.ConsoleText  = [];
            obj.CreateEventConnections();
%             disableKeyboard(obj);
%             disableMouse(obj);
        end
        
        function toggleKeyboard(obj,tf)
            obj.KeyHandler.Toggle(tf);
        end
        
        function enableKeyboard(obj)
            toggleKeyboard(obj,true);
        end
        
        function disableKeyboard(obj)
            toggleKeyboard(obj,false);
        end
        
        function [tf] = isKeyboardEnabled(obj)
            tf = obj.KeyHandler.isEnabled();
        end
        
        function toggleMouse(obj,tf)
            obj.MouseHandler.Toggle(tf);
        end
        
        function enableMouse(obj)
            toggleMouse(obj,true);
        end
        
        function disableMouse(obj)
            toggleMouse(obj,false);
        end
        
        function [tf] = isMouseEnabled(obj)
            tf = obj.MouseHandler.isEnabled();
        end
        
        function setConsoleText(obj,text,varargin)
            if(isempty(obj.ConsoleText))
                obj.ConsoleText  = consoleText(obj.FigureHandle,'');
            end
            set(obj.ConsoleText,'String',text,varargin{:});
        end
        
        function [text] = getConsoleText(obj)
            if(isempty(obj.ConsoleText))
                text = '';
                return;
            end
            text = obj.ConsoleText.String;
        end
        
        function toggleConsole(obj,status)
            set(obj.ConsoleText,'Visible',status);
        end
        
        function enableConsole(obj)
            toggleConsole(obj,true);
        end
        
        function disableConsole(obj)
            toggleConsole(obj,false);
        end
        
        function clearConsole(obj)
            setConsoleText(obj,'');
        end
        
        function [text] = getTitle(obj)
            text = get(obj.FigureHandle,'Name');
        end
        function setTitle(obj,text)
            set(obj.FigureHandle,'Name',text);
        end
    end

    methods( Access = protected, Hidden = true )
        function CreateMenu(obj)
        end
    end
    
    methods( Access = private, Hidden = true )
        function CreateEventConnections(obj)
            addlistener(obj.KeyHandler,  'EventKeyPress',         @(o,e) obj.EventKeyPress(e.Parent,e));
            addlistener(obj.KeyHandler,  'EventKeyRelease',       @(o,e) obj.EventKeyRelease(e.Parent,e));
            addlistener(obj.MouseHandler,'EventClick',            @(o,e) obj.EventMouseClick(e.Parent,e));
            addlistener(obj.MouseHandler,'EventLeftClick',        @(o,e) obj.EventMouseLeftClick(e.Parent,e));
            addlistener(obj.MouseHandler,'EventWheelClick',       @(o,e) obj.EventMouseWheelClick(e.Parent,e));
            addlistener(obj.MouseHandler,'EventRightClick',       @(o,e) obj.EventMouseRightClick(e.Parent,e));
            addlistener(obj.MouseHandler,'EventDoubleClick',      @(o,e) obj.EventMouseDoubleClick(e.Parent,e));
            addlistener(obj.MouseHandler,'EventRelease',          @(o,e) obj.EventMouseRelease(e.Parent,e));
            addlistener(obj.MouseHandler,'EventLeftRelease',      @(o,e) obj.EventMouseLeftRelease(e.Parent,e));
            addlistener(obj.MouseHandler,'EventWheelRelease',     @(o,e) obj.EventMouseWheelRelease(e.Parent,e));
            addlistener(obj.MouseHandler,'EventRightRelease',     @(o,e) obj.EventMouseRightRelease(e.Parent,e));
            addlistener(obj.MouseHandler,'EventGrab',             @(o,e) obj.EventMouseGrab(e.Parent,e));
            addlistener(obj.MouseHandler,'EventLeftGrab',         @(o,e) obj.EventMouseLeftGrab(e.Parent,e));
            addlistener(obj.MouseHandler,'EventWheelGrab',        @(o,e) obj.EventMouseWheelGrab(e.Parent,e));
            addlistener(obj.MouseHandler,'EventRightGrab',        @(o,e) obj.EventMouseRightGrab(e.Parent,e));
            addlistener(obj.MouseHandler,'EventGrabRelease',      @(o,e) obj.EventMouseGrabRelease(e.Parent,e));
            addlistener(obj.MouseHandler,'EventLeftGrabRelease',  @(o,e) obj.EventMouseLeftGrabRelease(e.Parent,e));
            addlistener(obj.MouseHandler,'EventWheelGrabRelease', @(o,e) obj.EventMouseWheelGrabRelease(e.Parent,e));
            addlistener(obj.MouseHandler,'EventRightGrabRelease', @(o,e) obj.EventMouseRightGrabRelease(e.Parent,e));
            addlistener(obj.MouseHandler,'EventMove',             @(o,e) obj.EventMouseMove(e.Parent,e));
            addlistener(obj.MouseHandler,'EventScroll',           @(o,e) obj.EventMouseScroll(e.Parent,e));
        end
    end
end