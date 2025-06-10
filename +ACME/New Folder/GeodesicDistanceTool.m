classdef GeodesicDistanceTool < SharedDataComponent
    properties( Access = private, Hidden = true )
        L
        AtL
        vertexListener
        G
        D
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = GeodesicDistanceTool(varargin)
            obj@SharedDataComponent(varargin{:});
            updateData(obj);
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            addProps(obj,'Mesh');
            addProps(obj,'VertexIndex');
            obj.vertexListener = addPropListener(obj,'VertexIndex',@(varargin) updateField(obj));
            addProps(obj,'Field');
        end
        
        function delete(obj)
            delete(obj.vertexListener);
        end
    end
    
    methods( Access = protected, Hidden = true )
        function updateData(obj)
            M   = getProps(obj,'Mesh');
            P   = M.Vertex;
            T   = M.Face;
            A   = barycentric_area(P,T);
            t   = diffusion_time(1,mean_edge_length(P,T));
            Ill = 0.0001*speye(row(P));
            [obj.G, obj.D, obj.L] = differential_operator(P,T);
            obj.AtL = decomposition(A+t*obj.L + Ill);
            obj.L   = decomposition(obj.L+Ill);
            updateField(obj)
        end
        
        function updateField(obj)
            M = getProps(obj,'Mesh');
            V = getProps(obj,'VertexIndex');
            F = zeros(nVertex(M),1);
            if(~isempty(V))
                P = M.Vertex;
                T = M.Face;
                F(V) = 1;
                F = obj.AtL\F;
                F = -normr(obj.G(F));
                F = obj.D(F);
                F = obj.L\F;
            end
            x = @(phi) phi;%    cos(2*pi*0.4*phi);
            setProps(obj,'Field',x(F));
        end
    end
end