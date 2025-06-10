function [T] = delta2transform(D)
T = arrayfun(@(i) [eul2rotm(D(i,4:6)) D(i,1:3)';0 0 0 1],(1:row(D))','UniformOutput',false);
end