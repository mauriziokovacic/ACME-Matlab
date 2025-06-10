function [obj] = compute_external(obj)
    obj = obj.compute_external_face();
    obj = obj.compute_external_vertex();
    obj = obj.compute_external_volume();
end