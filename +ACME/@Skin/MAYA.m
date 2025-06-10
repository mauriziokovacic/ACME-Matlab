function [P,N] = MAYA(obj,Pose)
[P,N] = Maya_Skinning(obj.M.P,obj.M.N,obj.W,Pose);
end