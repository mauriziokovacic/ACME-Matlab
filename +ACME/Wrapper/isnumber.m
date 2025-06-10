function [tf] = isnumber(a)
tf = isscalar(a)&&isnumeric(a);
end