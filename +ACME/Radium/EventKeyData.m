classdef (ConstructOnLoad) EventKeyData < event.EventData
    properties
        Parent
        Event
        Modifier
        Key
    end

    methods
        function [obj] = EventKeyData(Parent,EventName,Modifier,Key)
            obj.Parent   = Parent;
            obj.Event    = EventName;
            obj.Modifier = Modifier;
            obj.Key      = Key;
        end
    end
end