function [Data] = erase_empty(Data)
if( iscell(Data) )
    Data = Data(~cellfun('isempty',Data));
else
    Data(isempty(Data)) = [];
end
end