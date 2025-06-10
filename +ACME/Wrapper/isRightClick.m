function [tf] = isRightClick()
tf = strcmpi(get(gcf,'SelectionType'),'alt');
end