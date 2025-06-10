classdef AbstractPlugin < handle
    properties( Access = public, SetObservable )
        Parent
        Registered = false;
        Input      = [];
        Output     = [];
    end
    
    events
        RegistrationSuccess
        RegistrationFailed
    end
    
    methods( Access = public )
        function [obj] = AbstractPlugin(varargin)
            parser = inputParser;
            addRequired( parser, 'Parent', @(h) isa(h,'Viewer') );
            parse(parser,varargin{:});
            obj.Parent = parser.Results.Parent;
            addlistener(obj,'Registered','PostSet',@obj.EventRegistration);
        end
        
        function [obj] = connectProgramData(obj,program)
        end
        
        function [obj] = createUserInterface(obj,program)
        end
        
        function [obj] = programDataChanged(obj,program)
        end
        
        function buildInputData(obj,dataName)
            if( iscell(dataName) )
                for i = 1 : numel(dataName)
                    obj.Input.(dataName) = obj.Parent.getData(dataName{i});
                end
            else
                obj.Input = obj.Parent.getData(dataName);
            end
        end
        
        function buildOutputData(obj,dataName,propList)
            h = ViewerData();
            if( iscell(propList) )
                for i = 1 : numel(propList)
                    h.addprop(propList{i});
                end
            else
                h.addprop(propList);
            end
            obj.Output = obj.Parent.setData(dataName,h);
        end
    end
    
    methods( Access = private,...
             Hidden = true )
         function EventRegistration(obj,varargin)
             EventName = 'Registration';
             if(obj.Registered)
                 EventName = strcat(EventName,'Success');
             else
                 EventName = strcat(EventName,'Failed');
             end
             notify(obj,EventName);
         end
    end
end