classdef (ConstructOnLoad) EventDataCameraChanged < event.EventData
    properties
        Projection
        Position
        Target
        ViewAngle
    end

    methods
        function data = EventDataCameraChanged(Projection,Position,Target,ViewAngle)
            data.Projection = Projection;
            data.Position   = Position;
            data.Target     = Target;
            data.ViewAngle  = ViewAngle;
        end
    end
end