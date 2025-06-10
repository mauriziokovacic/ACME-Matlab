function [tf] = ispoolactive()
tf = ~isempty(gcp('nocreate'));
end