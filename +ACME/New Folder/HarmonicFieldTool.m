classdef HarmonicFieldTool < SharedDataComponent
    properties( Access = private, Hidden = true )
        L
        vertexListener
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = HarmonicFieldTool(varargin)
            obj@SharedDataComponent(varargin{:});
            
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            addProps(obj,'Mesh');
            addProps(obj,'VertexIndex');
            addProps(obj,'VertexSelection');
            obj.vertexListener = addPropListener(obj,'VertexIndex',@(varargin) updateField(obj));
            addProps(obj,'Field');
            [~,~,obj.L] = differential_operator(obj.Parent.Mesh.Vertex, obj.Parent.Mesh.Face);
        end
        
        function delete(obj)
            delete(obj.vertexListener);
        end
    end
    
    methods( Access = protected, Hidden = true )
        function updateField(obj)
            M = getProps(obj,'Mesh');
            V = getProps(obj,'VertexIndex');
            S = getProps(obj,'VertexSelection');
            F = zeros(nVertex(M),1);
            if(~isempty(V))
                i = V(~S);
                j = V( S);
                M = add_constraints(obj.L,...
                    [i;j],[]);
                F(i) =  1;
                F(j) = -1;
                F = linear_problem(M,F);
            end
            setProps(obj,'Field',F);
        end
    end
end