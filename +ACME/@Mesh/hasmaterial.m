function [tf] = hasmaterial(obj)
    tf = ~isempty(obj.M);
end