classdef AnimationTool < SharedDataComponent
    properties( Access = protected, Hidden = true )
        Pose
        frameListener
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = AnimationTool(varargin)
            obj@SharedDataComponent(varargin{:});
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            addProps(obj,'Anim');
            addProps(obj,'frameTime');
            obj.frameListener = addPropListener(obj,'frameTime',@(varargin) animate(obj));
        end
        
        function delete(obj)
            delete(obj.frameListener);
        end
    end
    
    methods( Access = protected )
        function animate(obj)
            computePose(obj);
            applyPose(obj);
        end
        
        function computePose(obj)
            A        = getProps(obj,'Anim');
            t        = getProps(obj,'frameTime');
            t        = (1-t) * A.TimeRange(1) + t * A.TimeRange(2);
            [T,R,S]  = fetchFrame(A,t);
            obj.Pose = {T,R,S};
        end
        
        function applyPose(obj)
        end
    end
end