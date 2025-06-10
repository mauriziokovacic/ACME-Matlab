classdef Edge
    properties
        ID
        H
    end
    
    methods
        function obj = Edge(varargin)
            obj.ID = -1;
            obj.H  = -1;
            if( nargin >= 1 )
                obj.ID = varargin{1};
            end
            if( nargin >= 2 )
                obj.H = varargin{2};
            end
        end
        
        function tf = valid(obj)
            tf = (obj.ID <= 0) & (obj.H <= 0);
        end
    end
end