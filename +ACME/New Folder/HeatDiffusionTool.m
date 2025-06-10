classdef HeatDiffusionTool < SharedDataComponent
    properties( Access = private, Hidden = true )
        A
        t
        L
        AtL
        vertexListener
        frameListener
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = HeatDiffusionTool(varargin)
            obj@SharedDataComponent(varargin{:});
            updateData(obj);
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            addProps(obj,'Mesh');
            addProps(obj,'VertexIndex');
            addProps(obj,'frameTime');
            obj.vertexListener = addPropListener(obj,'VertexIndex',@(varargin) updateField(obj));
            obj.frameListener = addPropListener(obj,'frameTime',@(varargin) updateTime(obj));
            addProps(obj,'Field');
        end
        
        function delete(obj)
            delete(obj.vertexListener);
            delete(obj.frameListener);
        end
    end
    
    methods( Access = protected, Hidden = true )
        function updateData(obj)
            M = getProps(obj,'Mesh');
            obj.t = getProps(obj,'frameTime');
            P = M.Vertex;
            T = M.Face;
            if(isempty(obj.t))
                obj.t = 0;
            end
            obj.t = obj.t * mesh_scale(P);
            [~,~,obj.L] = differential_operator(P,T);
            obj.A = barycentric_area(P,T);
            obj.AtL = decomposition(obj.A+obj.t*obj.L + 0.0001*speye(row(P)));
            updateField(obj)
        end
        
        function updateTime(obj)
            M = getProps(obj,'Mesh');
            P = M.Vertex;
            obj.t = getProps(obj,'frameTime');
            if(isempty(obj.t))
                obj.t = 0;
            end
            obj.t = obj.t * mesh_scale(P);
            obj.AtL = decomposition(obj.A+obj.t*obj.L + 0.0001*speye(row(P)));
            updateField(obj)
        end
        
        function updateField(obj)
            M = getProps(obj,'Mesh');
            V = getProps(obj,'VertexIndex');
            F = getProps(obj,'Phi');
            if( isempty(F) )
                F = zeros(nVertex(M),1);
            end
%             if(~isempty(V))
%                 F(V) = 1;
                F  = obj.AtL\F;
%             end
            setProps(obj,'Field',F);
        end
    end
end