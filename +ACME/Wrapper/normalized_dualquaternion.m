function [DQ] = normalized_dualquaternion( DQ )
% DQ = DQ ./ sum(DQ(:,1:4).^2,2).^0.5;
% DQ(:,5:8) = DQ(:,5:8) - dot(DQ(:,5:8),DQ(:,1:4),2) .* DQ(:,1:4);

l  = vecnorm(realdq(DQ),2,2);
DQ = DQ ./ l;
DQ = [realdq(DQ) , imagdq(DQ) - dotN(imagdq(DQ),realdq(DQ)) .* realdq(DQ)];
end
