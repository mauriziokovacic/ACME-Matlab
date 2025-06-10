classdef AbstractPickerPlugin < AbstractInteractionPlugin
    properties( Access = protected )
        KDTree
        MinPoint
        MaxPoint
    end
    
    methods( Access = public )
        function [obj] = AbstractPickerPlugin(varargin)
            obj@AbstractInteractionPlugin(varargin{:});
        end
    end
    
    methods( Access = protected )
        function [obj] = buildPickerData(obj,inputPoint,minP,maxP)
            if(nargin<4)
                maxP = max(inputPoint);
            end
            if(nargin<3)
                minP = min(inputPoint);
            end
            obj.KDTree   = KDTreeSearcher(inputPoint);
            obj.MinPoint = minP;
            obj.MaxPoint = maxP;
        end
        
        function [obj] = destroyPickerData(obj)
            obj.KDTree   = [];
            obj.MinPoint = [];
            obj.MaxPoint = [];
        end
    end
    
    methods( Access = protected, Sealed = true )
        function [X,i] = selectInRangePoint(obj,queryPoint,queryRadius)
            X = [];
            i = [];
            if( isempty(queryPoint) )
                return;
            end
            i = cell2mat(rangesearch(obj.KDTree,queryPoint,queryRadius)')';
            i = unique(i);
            X = obj.KDTree.X(i,:);
        end
        
        function [X,i] = selectkNearestPoint(obj,queryPoint,querySize)
            X = [];
            i = [];
            if( isempty(queryPoint) )
                return;
            end
            i = knnsearch(obj.KDTree,queryPoint,'K',querySize);
            X = obj.KDTree.X(i,:);
        end
    end
end