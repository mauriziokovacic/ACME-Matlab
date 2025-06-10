classdef AbstractComputePlugin < AbstractPlugin
    % need to access data
    properties
    end
    
    events
        
    end
    
    methods
        function [varargout] = eval(obj)
        end
        
        function [obj] = registerOutput(obj)
        end
    end
end