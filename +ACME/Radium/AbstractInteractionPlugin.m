classdef AbstractInteractionPlugin < AbstractPlugin
    properties( Access = public, SetObservable )
        Bypass  = false;
    end
    
    properties( Access = private, Hidden = true )
        Active  = false;
        Standby = false;
    end
    
    events
        RequestActivation
        RequestDeactivation
        RequestStandby
        ActivationGranted
        ActivationRejected
        DeactivationGranted
        DeactivationRejected
        StandbyEnabled
        StandbyDisabled
    end
    
    methods( Access = public )
        function [obj] = AbstractInteractionPlugin(varargin)
            obj@AbstractPlugin(varargin{:});
            addlistener(obj,'ActivationGranted',  @(o,e) obj.requestGranted(e.AckSource,true));
            addlistener(obj,'DeactivationGranted',@(o,e) obj.requestGranted(e.AckSource,false));
            addlistener(obj,'StandbyEnabled', @(o,e) obj.requestStandby(e.AckSource,true));
            addlistener(obj,'StandbyDisabled',@(o,e) obj.requestStandby(e.AckSource,false));
        end
        
        function [tf] = isActive(obj)
            tf = obj.Active;
        end
        
        function [tf] = isStandby(obj)
            tf = obj.Standby;
        end
        
        function [obj] = sendActivationRequest(obj,varargin)
            if(obj.Active)
                notify(obj,'RequestDeactivation');
            else
                notify(obj,'RequestActivation');
            end
        end
        
        function [obj] = activationRoutine(obj,program)
        end
        
        function [obj] = deactivationRoutine(obj,program)
        end
        
        function [obj] = standbyRoutine(obj,varargin)
        end
        
        
                
        function [obj] = EventKeyPress(obj,source,event)
        end
        
        function [obj] = EventKeyRelease(obj,source,event)
        end
        
        function [obj] = EventMouseClick(obj,source,event)
        end
        function [obj] = EventMouseLeftClick(obj,source,event)
        end
        function [obj] = EventMouseWheelClick(obj,source,event)
        end
        function [obj] = EventMouseRightClick(obj,source,event)
        end
        function [obj] = EventMouseDoubleClick(obj,source,event)
        end
        function [obj] = EventMouseRelease(obj,source,event)
        end
        function [obj] = EventMouseLeftRelease(obj,source,event)
        end
        function [obj] = EventMouseWheelRelease(obj,source,event)
        end
        function [obj] = EventMouseRightRelease(obj,source,event)
        end
        function [obj] = EventMouseGrab(obj,source,event)
        end
        function [obj] = EventMouseLeftGrab(obj,source,event)
        end
        function [obj] = EventMouseWheelGrab(obj,source,event)
        end
        function [obj] = EventMouseRightGrab(obj,source,event)
        end
        function [obj] = EventMouseMove(obj,source,event)
        end
        function [obj] = EventMouseScroll(obj,source,event)
        end
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = RequestAcknowledge(obj,requestName,status,source)
            switch requestName
                case 'RequestActivation'
                    if(status)
                        notify(obj,...
                            'ActivationGranted',...
                            EventRequestAck(source,requestName,'granted'));
                    else
                        notify(obj,...
                               'ActivationRejected',...
                               EventRequestAck(source,requestName,'rejected'));
                    end
                case 'RequestDeactivation'
                    if(status)
                        notify(obj,...
                               'DeactivationGranted',...
                               EventRequestAck(source,requestName,'granted'));
                    else
                        notify(obj,...
                               'DeactivationRejected',...
                               EventRequestAck(source,requestName,'rejected'));
                    end
                case 'RequestStandby'
                    if(status)
                        notify(obj,...
                               'StandbyEnabled',...
                               EventRequestAck(source,requestName,true));
                    else
                        notify(obj,...
                               'StandbyDisabled',...
                               EventRequestAck(source,requestName,true));
                    end
            end
        end
    end
    
    methods( Access = private, Hidden = true )
        function requestGranted(obj,program,status)
            obj.Active = status;
            if(status)
                obj.Standby = false;
                obj.activationRoutine(program);
            else
                obj.deactivationRoutine(program);
            end
        end
        
        function requestStandby(obj,program,status)
            obj.Standby = status;
            obj.standbyRoutine(program);
        end
    end
end