function [ModelPose] = local2model(skeleton,LocalPose)
tf = ~iscell(LocalPose);
if(tf)
    LocalPose = lin2mat(LocalPose);
end
ModelPose = cell(size(LocalPose));
R = skeletonRoot(skeleton);
for r = 1 : numel(R)
    i = R(r);
    ModelPose{i} = LocalPose{i};
    while(~isempty(i))
        b = i(1);
        child = successors(skeleton,b);
        if(~isempty(child))
            for c = 1: numel(child)
                j = child(c);
                ModelPose{j} = ModelPose{b} * LocalPose{j};
            end
        end
        i = [i(2:end);child];
    end
end
if(tf)
    ModelPose = mat2lin(ModelPose);
end
end