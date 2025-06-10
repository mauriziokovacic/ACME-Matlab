function [outputData] = l2m(skeleton,inputData,dataOperation)
outputData = inputData;
R = skeletonRoot(skeleton);
for r = 1 : numel(R)
    i = R(r);
    while(~isempty(i))
        b = i(1);
        child = successors(skeleton,b);
        if(~isempty(child))
            for c = 1: numel(child)
                j = child(c);
                outputData{j} = dataOperation(inputData{j},outputData{b});
            end
        end
        i = [i(2:end);child];
    end
end
end