function [out] = polyvert_fun(PData,VData,fun)
if(iscell(PData))
    f = @(V,i) V{i};
    p = @(V) V;
else
    f = @(V,i) V(i,:); 
    p = @(V) cell2mat(V);
end
out = p(arrayfun(@(i) helper(f(PData,i),VData,fun),(1:row(PData))','UniformOutput',false));
end

function [out] = helper(PData,VData,fun)
n   = numel(PData);
out = arrayfun(@(i) fun(VData(PData(i),:),...
                        VData(PData(mod(i,n)+1),:),...
                        VData(PData(mod(i+1+n,n)+1),:)),...
               1:numel(PData) );
end