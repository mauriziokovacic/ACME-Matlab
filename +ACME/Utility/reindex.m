function [ind,I,J] = reindex(ind)
if(iscell(ind))
    I = unique(cell2mat(cellfun(@(i) make_column(i(:)),ind,'UniformOutput',false)));
else
    I = unique(ind);
end
J    = (1:numel(I))';
i    = zeros(numel(I),1);
i(I) = J;
if(iscell(ind))
    ind = cellfun(@(j) i(j)',ind,'UniformOutput',false);
else
    ind = i(ind);
end
end