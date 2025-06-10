function [tf]  = isPerspective(obj)
tf = strcmp(obj.Projection,'perspective');
end