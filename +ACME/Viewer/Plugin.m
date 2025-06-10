classdef Plugin < handle
    properties( Access = public )
        Parent = [];
        UI     = [];
    end
    
    methods
        function [obj] = Plugin(parent,varargin)
            if( ( nargin >= 1 ) && ~isempty(parent) )
                obj.Parent = parent;
            end
        end
        
        function [obj] = deleteUserInterface(obj)
            delete(obj.UI);
        end
        
        function [obj] = delete(obj)
            obj.deleteUserInterface();
        end
    end
    
    methods
        function [obj] = createUserInterface(obj)
        end
        
        function [obj] = eval(obj)
        end
        
        function [obj] = MouseEventMove(obj,source,event)
        end
        
        function [obj] = MouseEventClick(obj,source,event)
        end
        
        function [obj] = MouseEventRelease(obj,source,event)
        end
        
        function [obj] = MouseEventWheel(obj,source,event)
        end
        
        function [obj] = KeyEventPress(obj,source,event)
        end
        
        function [obj] = KeyEventRelease(obj,source,event)
        end
    end
end