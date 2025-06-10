function [Index] = GetBufferDataIndex(FigureSize,ScreenPoint,DataSize)
FSize = [1 1; FigureSize];
Index = ScreenPoint;
Index = normalize(Index,FSize(1,:),FSize(2,:));
Index = round(1+[1-Index(:,2) Index(:,1)] .* DataSize);
Index( ~in_range(Index,[1 1],DataSize),: ) = [];
end