function [Pose] = linearize_pose(Pose)
Pose = cell2mat(cellfun(@(t) mat2lin(t),Pose,'UniformOutput',false));
end