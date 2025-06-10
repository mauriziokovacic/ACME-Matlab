classdef EuclideanDistanceTool < SharedDataComponent
    properties( Access = private, Hidden = true )
        pointListener
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = EuclideanDistanceTool(varargin)
            obj@SharedDataComponent(varargin{:});
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            addProps(obj,'Mesh');
            addProps(obj,'PointSelection');
            obj.pointListener = addPropListener(obj,'PointSelection',@(varargin) updateField(obj));
            addProps(obj,'Field');
        end
        
        function delete(obj)
            delete(obj.pointListener);
        end
    end
    
    methods( Access = protected, Hidden = true )
        function updateField(obj)
            M = getProps(obj,'Mesh');
            P = getProps(obj,'PointSelection');
            F = zeros(nVertex(M),1);
            if(~isempty(P))
                F = distance(M.Vertex,P,2);
            end
            setProps(obj,'Field',F);
        end
    end
end