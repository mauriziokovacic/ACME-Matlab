function [Q] = from_barycentric(VData,FData,FID,BCoord)
Pi = VData(FData(FID,1),:);
Pj = VData(FData(FID,2),:);
Pk = VData(FData(FID,3),:);
Q  = BCoord(:,1).*Pi+BCoord(:,2).*Pj+BCoord(:,3).*Pk;
end