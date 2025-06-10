classdef (ConstructOnLoad) BrushRadiusChangedEventData < event.EventData
   properties
      Radius
   end
   
   methods
      function data = BrushRadiusChangedEventData(Radius)
         data.Radius = Radius;
      end
   end
end