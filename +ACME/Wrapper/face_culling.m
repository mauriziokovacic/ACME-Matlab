function [FData] = face_culling(FData,NData,Direction,Type)
if(nargin<4||isempty(Type))
    Type = 'back';
end
FIndex = [];
if(strcmpi(Type,'back'))
    FIndex = find(sum(NData.*Direction,2)>0);
end
if(strcmpi(Type,'front'))
    FIndex = find(sum(NData.*Direction,2)<0);
end
FData(FIndex,:) = NaN(numel(FIndex),col(FData));
end