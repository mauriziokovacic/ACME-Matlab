function [C] = homo2cart(H)
C = H(:,1:end-1) ./ H(:,end);
end