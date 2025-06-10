function [tf] = polyContains(P,i)
if(iscell(P))
    tf = cell2mat(cellfun(@(p) any(ismember(p,i)),P));
else
    tf = any(ismember(P,i),2);
end
end