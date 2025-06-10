function [P,N,C] = COR(obj,Pose,CoR)
[P,N,C] = Center_Of_Rotation(obj.M.P,obj.M.N,obj.W,Pose,CoR);
end