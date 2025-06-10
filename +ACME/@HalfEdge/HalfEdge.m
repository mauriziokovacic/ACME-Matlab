classdef HalfEdge
    properties
        ID
        V
        F
        Next
        Prev
    end
    
    methods
        function obj = HalfEdge(varargin)
            obj.ID   = -1;
            obj.V    = -1;
            obj.F    = -1;
            obj.Next = -1;
            obj.Prev = -1;
            if( nargin >= 1 )
                obj.ID = varargin{1};
            end
            if( nargin >= 2 )
                obj.V = varargin{2};
            end
            if( nargin >= 3 )
                obj.F = varargin{3};
            end
            if( nargin >= 4 )
                obj.Next = varargin{4};
            end
            if( nargin >= 5 )
                obj.Prev = varargin{5};
            end
        end
        
        function tf = valid(obj)
            tf = (obj.ID <= 0) & (obj.V <= 0) & (obj.Next <= 0) & (obj.Prev <= 0);
        end
    end
end