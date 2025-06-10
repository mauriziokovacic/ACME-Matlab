classdef CurveSelectionTool < SharedDataComponent
    properties( Access = private, Hidden = true )
        curveListener
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = CurveSelectionTool(varargin)
            obj@SharedDataComponent(varargin{:});
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            addProps(obj,'Mesh');
            addProps(obj,'Curve');
            addProps(obj,'VertexIndex');
            obj.curveListener = addPropListener(obj,'Curve',@(varargin) updateSelection(obj));
        end
    end
    
    methods( Access = protected, Hidden = true )
        function updateSelection(obj)
            M = getProps(obj,'Mesh');
            C = getProps(obj,'Curve');
            C = C{end};
            I = unique(M.knn(C,1,false));
            setProps(obj,'VertexIndex',I);
        end
    end
end