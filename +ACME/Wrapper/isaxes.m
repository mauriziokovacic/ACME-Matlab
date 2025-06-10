function [tf] = isaxes(h)
    tf = arrayfun(@(hh) isa(hh,'matlab.graphics.axis.Axes'),h);
end