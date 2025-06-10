function [P,N] = LBS(obj,Pose)
[P,N] = Linear_Blend_Skinning(obj.M.P,obj.M.N,obj.W,Pose);
end