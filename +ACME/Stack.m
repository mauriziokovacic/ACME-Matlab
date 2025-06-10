classdef Stack < handle
    properties(Access = private, Hidden = true)
        Buffer
        Head
        Amort
    end
    
    methods(Access = public, Sealed = true)
        function [obj] = Stack(varargin)
            obj.Head = 0;
            obj.Buffer = [];
            obj.Amort = 100;
        end
        
        function [out] = top(obj)
            out = obj.Buffer(obj.Head);
        end
        
        function pop(obj)
            if(~empty(obj))
                obj.Head = obj.Head - 1;
            end
        end
        
        function push(obj, data)
            obj.Head = obj.Head + 1;
            if(obj.Head > numel(obj.Buffer))
                obj.Buffer = [obj.Buffer, nan(1,obj.Amort)];
            end
            obj.Buffer(obj.Head) = data;
        end
        
        function [tf] = empty(obj)
            tf = obj.Head <= 0;
        end
        
        function [out] = size(obj)
            out = obj.Head;
        end
        
        function compact(obj)
            obj.Buffer = obj.Buffer(1:obj.Head);
        end
        
        function [out] = to_data(obj)
            obj.compact();
            out = obj.Buffer;
        end
    end
end