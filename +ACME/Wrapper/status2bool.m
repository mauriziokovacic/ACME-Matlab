function [tf] = status2bool(str)
tf = strcmpi(str(1:6),'Enable');
end