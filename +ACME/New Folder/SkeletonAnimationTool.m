classdef SkeletonAnimationTool < AnimationTool
    methods( Access = public, Sealed = true )
        function [obj] = SkeletonAnimationTool(varargin)
            obj@AnimationTool(varargin{:});
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            registerProps@AnimationTool(obj);
            addProps(obj,'Skel');
        end
    end
    
    methods( Access = protected )
        function applyPose(obj)
            S = getProps(obj,'Skel');
            assignPosefromDelta(S,[obj.Pose{1},obj.Pose{2}]);
        end
    end
end