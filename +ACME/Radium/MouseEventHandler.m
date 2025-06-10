classdef MouseEventHandler < EventHandler
    events
        EventClick
        EventLeftClick
        EventWheelClick
        EventRightClick
        EventDoubleClick
        
        EventRelease
        EventLeftRelease
        EventWheelRelease
        EventRightRelease
        
        EventGrab
        EventLeftGrab
        EventWheelGrab
        EventRightGrab
        
        EventGrabRelease
        EventLeftGrabRelease
        EventWheelGrabRelease
        EventRightGrabRelease
        
        EventMove
        EventScroll
    end
    
    properties
        Press
        Grab
    end
    
    methods( Access = public )
        function [obj] = MouseEventHandler(interaction_handler)
            obj@EventHandler(interaction_handler,'EventMouse');
            obj.Press = false;
            obj.Grab  = false;
        end
    
        function [obj] = ThrowMouseEvent(obj,EventName,Button,Modifier,Key,Position,Data)
            event = EventMouseData(obj.Parent,EventName,Button,Modifier,Key,Position,Data);
            obj.dispatchEvent(obj.Parent,event);
        end
    end
    
    methods( Access = protected, Hidden = true )
        function [obj] = dispatchEvent(obj,source,event)
            persistent button;
            e = event.Event;
            switch e
                case 'WindowScrollWheel'
                    event.Button = 'wheel';
                    event.Event  = 'EventScroll';
                    notify(obj,event.Event,event);
                case 'WindowMousePress'
                    obj.Press  = true;
                    event.Button = obj.checkButton(event.Button,event.Modifier);
                    button = event.Button;
                    if(strcmpi(button,'double'))
                        event.Event  = 'EventDoubleClick';
                        notify(obj,event.Event,event);
                    else
                        switch button
                            case 'left'
                                event.Event  = 'EventLeftClick';
                            case 'right'
                                event.Event  = 'EventRightClick';
                            case 'wheel'
                                event.Event  = 'EventWheelClick';
                        end
                        notify(obj,event.Event,event);
                        event.Event  = 'EventClick';
                        notify(obj,event.Event,event);
                    end
                case 'WindowMouseRelease'
                    event.Button = obj.checkButton(event.Button,event.Modifier);
                    button = [];
                    obj.Press  = false;
                    if(obj.Grab)
                        switch event.Button
                            case 'right'
                                event.Event  = 'EventRightGrabRelease';
                            case 'wheel'
                                event.Event  = 'EventWheelGrabRelease';
                            otherwise
                                event.Event  = 'EventLeftGrabRelease';
                        end
                        notify(obj,event.Event,event);
                        event.Event  = 'EventGrabRelease';
                        notify(obj,event.Event,event);
                    end
                    obj.Grab   = false;
                    switch event.Button
                        case 'right'
                            event.Event  = 'EventRightRelease';
                        case 'wheel'
                            event.Event  = 'EventWheelRelease';
                        otherwise
                            event.Event  = 'EventLeftRelease';
                    end
                    notify(obj,event.Event,event);
                    event.Event  = 'EventRelease';
                    notify(obj,event.Event,event);
                case 'WindowMouseMotion'
                    if(obj.Press)
                        obj.Grab     = true;
                        event.Button = button;
                        event.Event  = 'EventGrab';
                        notify(obj,event.Event,event);
                        switch button
                            case 'right'
                                event.Event = 'EventRightGrab';
                            case 'wheel'
                                event.Event = 'EventWheelGrab';
                            otherwise
                                event.Event = 'EventLeftGrab';
                        end
                        notify(obj,event.Event,event);
                    else
                        event.Button = [];
                    end
                    event.Event = 'EventMove';
                    notify(obj,event.Event,event);
            end
        end
        
        function [button] = checkButton(obj,SelectionType,Modifier)
            switch SelectionType
                case 'normal'
                    button = 'left';
                case 'extend'
                    if(any(strcmpi(Modifier,'shift')))
                        button = 'left';
                    else
                        button = 'wheel';
                    end
                case 'alt'
                    if(any(strcmpi(Modifier,'control')))
                        button = 'left';
                    else
                        button = 'right';
                    end
                case 'open'
                    button = 'double';
            end
        end
    end
end




