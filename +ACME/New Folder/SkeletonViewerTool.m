classdef SkeletonViewerTool < ViewerTool
    properties( Access = protected, Hidden = true )
        skelListener
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = SkeletonViewerTool(varargin)
            obj@ViewerTool(varargin{:});
            setTitle(obj,'Skeleton Viewer Tool');
            setConsoleText(obj,['\textbf{Bones}: ',num2str(numel(obj.Parent.Skel.BoneList))]);
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            addProps(obj,'Skel');
            obj.skelListener = addlistener(obj.Parent.Skel,'PoseChanged',@(varargin) updateSkeleton(obj));
        end
        
        function [h] = showObject(obj)
            if(isvalid(obj.AxesHandle.AxesHandle))
                h = obj.Parent.Skel.show('Parent',obj.AxesHandle.AxesHandle);
            end
        end
        
        function delete(obj)
            delete(obj.skelListener);
        end
    end
    
    methods( Access = protected )
        function updateSkeleton(obj)
            if(~isvalid(obj.ObjectHandle))
                return;
            end
            delete(obj.ObjectHandle);
            obj.ObjectHandle = [];
            obj.ObjectHandle = showObject(obj);
        end
    end
end