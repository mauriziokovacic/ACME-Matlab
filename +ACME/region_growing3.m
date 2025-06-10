function [R] = region_growing3(AData, NData, seed)
n = numel(seed);
if(n > 1)
    R = cell(numel(seed),1);
    for i = 1 : n
        R{i} = region_growing_fcn(AData, NData, seed(i));
    end
else
    R = region_growing_fcn(AData, NData, seed);
end
end

function [R] = region_growing_fcn(AData, NData, seed)
visited = false(row(AData),1);
R       = ones(row(AData),1);
index   = Stack();
value   = Stack();
index.push(seed);
value.push(0);
while(~empty(index))
    i = index.top();
    v = value.top();
    index.pop();
    value.pop();
    if(R(i)<v)
        continue;
    end
    R(i) = v;
    for a = AData{i}
        vv = v+(1-dotN(NData(i,:), NData(a,:)));
        index.push(a);
        value.push(vv);
    end
    
end
%R = unique(R.to_data());
end