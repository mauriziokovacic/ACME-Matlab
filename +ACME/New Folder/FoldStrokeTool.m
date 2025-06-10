classdef FoldStrokeTool < SharedDataComponent
    properties( Access = private, Hidden = true )
        curveListener
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = FoldStrokeTool(varargin)
            obj@SharedDataComponent(varargin{:});
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            addProps(obj,'Skin');
            addProps(obj,'Fold');
            addProps(obj,'HandleIndex');
            addProps(obj,'Curve');
            obj.curveListener = addPropListener(obj,...
                                                'Curve',...
                                                @(varargin) createFoldStroke(obj));
        end
        
        function delete(obj)
            delete(obj.curveListener);
        end
    end
    
    methods( Access = public )
        function createFoldStroke(obj)
            S = getProps(obj,'Skin');
            H = getProps(obj,'HandleIndex');
            C = getProps(obj,'Curve');
            F = getProps(obj,'Fold');
            C = C{end};
            C = S.Mesh.knn(C);
            s = FoldStroke('Point',C,'Skin',S,'Handle',H,'Strength',1);
            s.setHardPressure();
            F = [F;s];
            setProps(obj,'Fold',F);
        end
    end
end