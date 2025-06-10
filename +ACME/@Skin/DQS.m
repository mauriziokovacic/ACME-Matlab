function [P,N] = DQS(obj,Pose)
[P,N] = Dual_Quaternion_Skinning(obj.M.P,obj.M.N,obj.W,Pose);
end