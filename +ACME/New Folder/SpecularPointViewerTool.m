classdef SpecularPointViewerTool < ModelViewerTool
    properties( Access = public, SetObservable )
        WAdj
    end
    
    properties( Access = private, Hidden = true )
        PointHandle
        QuivHandle
        vertexListener
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = SpecularPointViewerTool(varargin)
            obj@ModelViewerTool(varargin{:});
            setTitle(obj,'Specular Point Viewer');
            hold on;
            obj.WAdj = weight2adjacency(obj.Parent.Skin.Weight);
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            registerProps@ModelViewerTool(obj);
            addProps(obj,'Skin');
            addProps(obj,'Skel');
            addProps(obj,'VertexIndex');
            obj.vertexListener = addPropListener(obj,'VertexIndex',@(varargin) selectVertex(obj));
        end
        
        function delete(obj)
            delete(obj.vertexListener);
        end
    end
    
    methods( Access = protected, Hidden = true )
        function selectVertex(obj)
            M = getProps(obj,'Mesh');
            W = getProps(obj,'Skin');
            S = getProps(obj,'Skel');
            V = getProps(obj,'VertexIndex');
            
            delete(obj.PointHandle);
            delete(obj.QuivHandle);
            obj.ObjectHandle.FaceAlpha = 1;
            if(isempty(V))
                return;
            end
            obj.ObjectHandle.FaceAlpha = 0.2;
            
            k = find(W.Weight(V,:))';
            [~,j] = find(obj.WAdj(k,:));
            j = unique([k;j]);
            
            p = referenceJointPosition(S);
            n = referenceJointOrientation(S);
            p = p(j,:);
            n = n(j,:);
            P = M.Vertex(V,:);
            Q = specular_direction(normr(cross(n,cross(P-p,n,2),2)),P-p);
            
            obj.PointHandle = point3(P,20,'filled','r','Parent',obj.AxesHandle.AxesHandle);
            obj.PointHandle = [obj.PointHandle;point3(Q,20,'filled','g','Parent',obj.AxesHandle.AxesHandle)];
            obj.QuivHandle  = quiv3(P,p-P,'Color','r','Autoscale','off','Parent',obj.AxesHandle.AxesHandle);
            obj.QuivHandle  = [obj.QuivHandle;quiv3(p,Q-p,'Color','g','Autoscale','off','Parent',obj.AxesHandle.AxesHandle)];
        end
    end
end