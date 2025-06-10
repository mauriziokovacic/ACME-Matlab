function [Animation] = convertAnimation(S,Rest,Frame)
Animation = AbstractAnimation.createFromSkeleton(S);
S0        = BaseSkeleton.createFromSkeletonPose(S,Rest);
RefPose   = referenceModelPose(S0);
for f = 1 : numel(Frame)
    F       = lin2mat(Frame{f});
    St      = BaseSkeleton.createFromSkeletonPose(S,relative2current(Rest,F));
    CurPose = referenceModelPose(St);
    RelPose = current2relative(RefPose,CurPose);
    assignCurrentFromRelativePose(S0,RelPose);
    [t,r]   = currentDelta(S0);
    for i = 1 : numnodes(S)
        Animation.Translation(i).insertKey(f,t(i,:));
        Animation.Rotation(i).insertKey(f,r(i,:));
    end
end
updateTimeRange(Animation);
end