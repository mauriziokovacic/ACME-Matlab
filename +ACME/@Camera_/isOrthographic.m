function [tf]  = isOrthographic(obj)
tf = strcmp(obj.Projection,'orthographic');
end