classdef BaseJoint < Editable
    properties( Access = public, SetObservable )
        AttachedBone
    end
    
    methods
        function [obj] = BaseJoint(varargin)
            obj@Editable(varargin{:});
        end
        
        function [M] = referenceFrame(obj)
            M = [zeros(3),referenceData(obj)'];
            if(isextremity(obj))
                M = M + eye(3,4);
            else
                M = M + referenceFrame(obj.AttachedBone);
            end
        end
        
        function [M] = currentFrame(obj)
            M = [zeros(3),currentData(obj)'];
            if(isextremity(obj))
                M = M + eye(3,4);
            else
                M = M + currentFrame(obj.AttachedBone);
            end
        end
        
        function setReferenceFrame(obj,frame)
            obj.Data = frame(1:3,4)';
            if(~isextremity(obj))
                setReferenceFrame(obj.AttachedBone,frame);
            end
        end
        
        function setCurrentFrame(obj,frame)
            obj.Delta = frame(1:3,4)' - obj.Data;
            if(~isextremity(obj))
                setCurrentFrame(obj.AttachedBone,frame);
            end
        end
        
        function [tf] = isextremity(obj)
            tf = arrayfun(@(j) isempty(j.AttachedBone),obj);
        end
        
        function [h] = show(obj,radius,varargin)
            if(nargin<2)
                radius = 1;
            end
            h = SpherePatch(currentData(obj),radius,8,'EdgeColor','k',varargin{:});
        end
    end
end
