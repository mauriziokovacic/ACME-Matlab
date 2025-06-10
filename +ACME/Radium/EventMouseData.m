classdef (ConstructOnLoad) EventMouseData < event.EventData
    properties
        Parent
        Event
        Button
        Modifier
        Key
        Position
        Data
    end

    methods
        function [obj] = EventMouseData(Parent,EventName,Button,Modifier,Key,Position,Data)
            obj.Parent   = Parent;
            obj.Event    = EventName;
            obj.Button   = Button;
            obj.Modifier = Modifier;
            obj.Key      = Key;
            obj.Position = Position;
            obj.Data     = Data;
        end
    end
end