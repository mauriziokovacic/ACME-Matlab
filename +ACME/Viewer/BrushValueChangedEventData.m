classdef (ConstructOnLoad) BrushValueChangedEventData < event.EventData
   properties
      Value
   end
   
   methods
      function data = BrushValueChangedEventData(Value)
         data.Value = Value;
      end
   end
end