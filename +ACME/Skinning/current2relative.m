function [Pose] = current2relative( RestPose, CurrentPose )
Pose = cellfun(@(r,c) c/r,RestPose,CurrentPose,'UniformOutput',false);
end