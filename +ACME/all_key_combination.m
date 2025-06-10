function [txt] = all_key_combination()
modifier = {'','control+','alt+','shift+'};
letter   = cellstr(('a':'z')');
i = num2cell(repmat((1:numel(modifier)),numel(modifier),1),2);
i = num2cell(combvec(i{:})',1);
i = arrayfun(@(varargin) unique([varargin{:}]),i{:},'UniformOutput',false);
i = cellfun(@(c) [c ones(1,numel(modifier)-numel(c))],i,'UniformOutput',false);
i = cell2mat(i);
i = sort(i,2);
i = unique(i,'rows');
n = row(i);
m = numel(letter);
i = repmat(i,m,1);
j = repelem((1:m)',n,1);
txt = strcat(modifier(i(:,1)),modifier(i(:,2)),modifier(i(:,3)),modifier(i(:,4)))';
txt = strcat(txt,letter(j));
end