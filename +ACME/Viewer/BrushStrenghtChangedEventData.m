classdef (ConstructOnLoad) BrushStrenghtChangedEventData < event.EventData
   properties
      Strenght
   end
   
   methods
      function data = BrushStrenghtChangedEventData(Strenght)
         data.Strenght = Strenght;
      end
   end
end