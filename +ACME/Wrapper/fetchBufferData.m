function [BData] = fetchBufferData(Buffer,bufferIndex)
BData = [];
if(isempty(bufferIndex))
    return;
end
flag = ndims(Buffer)==3;
if(flag)
    i = sub2ind(size(Buffer),...
                repelem(bufferIndex(:,1),3,1),...
                repelem(bufferIndex(:,2),3,1),...
                repmat([1 2 3]',row(bufferIndex),1));
    
else
    i = sub2ind(size(Buffer),bufferIndex(:,1),bufferIndex(:,2));
end
BData = Buffer(i);
if(ndims(Buffer)==3)
    BData = reshape(BData,3,row(bufferIndex))';
end
end