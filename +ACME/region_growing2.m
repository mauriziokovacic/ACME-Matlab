function [R] = region_growing2(AData, NData, seed)
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
R       = Stack();
stack   = Stack();
stack.push(seed);
while(~empty(stack))
    i = stack.top();
    stack.pop();
    if(visited(i))
        continue;
    end
    visited(i) = true;
    if(dotN(NData(seed,:), NData(i,:)) >= 0)
        R.push(i);
        for a = AData{i}
            stack.push(a);
        end
    end
end
R = R.to_data();
end