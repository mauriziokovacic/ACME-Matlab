function [Pose] = relative2current( RestPose, RelativePose )
if(~iscell(RestPose))
    RestPose = lin2mat(RestPose);
end
if(~iscell(RelativePose))
    RelativePose = lin2mat(RelativePose);
end
Pose = cellfun(@(r,p) p*r,RestPose,RelativePose,'UniformOutput',false);
end