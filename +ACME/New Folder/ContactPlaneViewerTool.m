classdef ContactPlaneViewerTool < ModelViewerTool
    properties( Access = public, SetObservable )
        Side
        CData
    end
    
    properties( Access = private, Hidden = true )
        PlaneHandle
        vertexListener
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = ContactPlaneViewerTool(varargin)
            obj@ModelViewerTool(varargin{:});
            setTitle(obj,'Contact Plane Viewer');
            obj.Side = 3;
            obj.CData = [1 1 0];
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            registerProps@ModelViewerTool(obj);
            addProps(obj,'Contact');
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
            V = getProps(obj,'VertexIndex');
            X = getProps(obj,'Contact');
            delete(obj.PlaneHandle);
            obj.PlaneHandle = [];
            obj.ObjectHandle.FaceAlpha = 1;
            if(isempty(V))
                return;
            end
            obj.ObjectHandle.FaceAlpha = 0.2;
            obj.PlaneHandle = plane3(X.Point(V,:),X.Normal(V,:),mesh_scale(M.Vertex)/10,obj.CData,'Parent',obj.AxesHandle.AxesHandle);
        end
    end
end