classdef (ConstructOnLoad) EventRequestAck < event.EventData
    properties
        AckSource
        RequestName
        Status
    end

    methods
        function data = EventRequestAck(AckSource,RequestName,Status)
            data.AckSource   = AckSource;
            data.RequestName = RequestName;
            data.Status      = Status;
        end
    end
end