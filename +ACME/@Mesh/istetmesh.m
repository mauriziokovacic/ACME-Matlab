function [tf] = istetmesh(obj)
    tf = obj.isvolumetric() & istet(obj.V);
end