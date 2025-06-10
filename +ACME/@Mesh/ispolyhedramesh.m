function [tf] = ispolyhedramesh(obj)
    tf = obj.isvolumetric() & ispoly(obj.V);
end