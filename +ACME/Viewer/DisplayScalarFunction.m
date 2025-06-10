function [h] = DisplayScalarFunction(h,FData)
DisplayColor(h,FData);
ax = ancestor(h,'axes');
colorbar(ax);
end
