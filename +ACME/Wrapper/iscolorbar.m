function [tf] = iscolorbar(h)
    tf = arrayfun(@(hh) isa(hh,'matlab.graphics.illustration.ColorBar'),h);
end