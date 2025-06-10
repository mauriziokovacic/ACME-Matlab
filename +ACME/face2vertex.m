function [U] = face2vertex(VData,FData,WData,varargin)
[I,P] = poly2lin(FData);
if( nargin < 3 )
    WData = ones(row(FData),1);
end
if(iscell(WData))
    WData = cell2mat(cellfun(@(w) w',WData,'UniformOutput',false));
else
    WData = reshape(WData',numel(WData),1);
    if(numel(WData)==row(FData))
        WData = WData(P,:);
    end
end
U = accumarrayN(I,WData .* VData(P,:),varargin{:});
W = accumarray( I,WData              ,varargin{:});
U = U./W;
end