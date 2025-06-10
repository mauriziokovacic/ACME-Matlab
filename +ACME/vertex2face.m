function [U] = vertex2face(VData,FData,WData)
if( nargin < 3 )
    WData = ones(size(VData,1),1);
end
[I,P] = poly2lin(FData);
if(row(WData)==row(VData))
    WData = WData(I,:);    
end
if(row(WData)==row(FData))
    if(iscell(WData))
        WData = cell2mat(cellfun(@(w) w',WData,'UniformOutput',false));
    else
        WData = reshape(WData',numel(WData),1);
    end
end
U = accumarrayN(P,WData.*VData(I,:),[row(FData),col(VData)]);
W = accumarray( P,WData            ,[row(FData),1]);
U = U./W;
end