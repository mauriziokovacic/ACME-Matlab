function [T] = linearize_transform(T)
T = cell2mat(cellfun(@(t) mat2lin(t),T,'UniformOutput',false));
end
