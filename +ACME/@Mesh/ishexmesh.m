function [tf] = ishexmesh(obj)
    tf = obj.isvolumetric() & ( size(obj.V,2) == 6 );
end