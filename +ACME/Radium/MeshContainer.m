classdef MeshContainer < handle
    properties( Access = public, SetObservable )
        Vertex
        Normal
        UV
        Face
        Handle
    end
    
    methods
        function [obj] = MeshContainer(varargin)
            obj.Handle = [];
            obj.createConnections();
        end
    end
    
    methods( Access = private, Hidden = true )
        function [obj] = createConnections(obj)
            addlistener(obj,'Vertex','PostSet',@obj.updateVertex);
            addlistener(obj,'Normal','PostSet',@obj.updateNormal);
            addlistener(obj,'Face'  ,'PostSet',@obj.updateFace);
        end
        
        function [obj] = updateVertex(obj,varargin)
            if(isempty(obj.Handle))
                return;
            end
            obj.Handle.Vertices = obj.Vertex;
        end
        
        function [obj] = updateNormal(obj,varargin)
            if(isempty(obj.Handle))
                return;
            end
            obj.Handle.VertexNormal = obj.Normal;
        end
        
        function [obj] = updateFace(obj,varargin)
            if(isempty(obj.Handle))
                return;
            end
            obj.Handle.Faces = obj.Face;
        end
    end
end