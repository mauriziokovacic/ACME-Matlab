function [A] = skinning_region_area(P,T,TID)
A = triangle_area(P,T);
A = accumarray(TID,A);
end