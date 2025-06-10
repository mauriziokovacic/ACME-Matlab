function [LocalPose] = model2local(skeleton,ModelPose)
tf = ~iscell(ModelPose);
if(tf)
    ModelPose = lin2mat(ModelPose);
end
LocalPose = cell(size(ModelPose));
for i = 1 : numel(LocalPose)
    LocalPose{i} = eye(4);
end
R = skeletonRoot(skeleton);
for i = 1 : numel(R)
    i = R(i);
    LocalPose{i} = ModelPose{i};
    while(~isempty(i))
        b = i(1);
        child = successors(skeleton,b);
        if(~isempty(child))
            for c = 1: numel(child)
                j = child(c);
                LocalPose{j} = ModelPose{b}\ModelPose{j};
            end
        end
        i = [i(2:end);child];
    end
end
if(tf)
    LocalPose = mat2lin(LocalPose);
end
end