classdef ModelCompareTool < ModelViewerTool
    properties( Access = public, SetObservable )
        AHandle
        BHandle
    end
    
    properties( Access = private, Hidden = true )
        aListener
        bListener
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = ModelCompareTool(varargin)
            obj@ModelViewerTool(varargin{:});
            setTitle(obj,'Model Compare Viewer');
            obj.ObjectHandle.FaceColor = 'interp';
            obj.ObjectHandle.FaceVertexCData = zeros(nVertex(obj.Parent.Mesh),1);
        end
        
        function setComparison(obj,AModel,BModel)
            obj.AHandle = AModel.ObjectHandle;
            obj.BHandle = BModel.ObjectHandle;
            delete(obj.aListener);
            delete(obj.bListener);
            obj.aListener = addlistener(AModel.ObjectHandle,'Vertices','PostSet',@(varargin) updateData(obj));
            obj.bListener = addlistener(BModel.ObjectHandle,'Vertices','PostSet',@(varargin) updateData(obj));
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            registerProps@ModelViewerTool(obj);
            addProps(obj,'Compare');
        end
        
        function delete(obj)
            delete(obj.aListener);
            delete(obj.bListener);
        end
    end
    
    methods( Access = protected, Hidden = true )
        function updateData(obj)
            C = distance(obj.AHandle.Vertices,obj.BHandle.Vertices);
            obj.ObjectHandle.FaceVertexCData = C;
            setProps(obj,'Compare',C);
        end
    end
end
