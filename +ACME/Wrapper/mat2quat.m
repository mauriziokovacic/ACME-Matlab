function [Q] = mat2quat(T)
if(iscell(T))
    Q = cell2mat(cellfun(@(t) rotm2quat(t(1:3,1:3)),T,'UniformOutput',false));
else
    Q = mat2quat(lin2mat(T));
end
end