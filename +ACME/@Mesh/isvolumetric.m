function [tf] = isvolumetric(obj)
    tf = ~isempty(obj.V);
end