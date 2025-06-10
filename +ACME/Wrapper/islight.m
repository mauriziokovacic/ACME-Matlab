function [tf] = islight(h)
    tf = arrayfun(@(hh) isa(hh,'matlab.graphics.primitive.Light'),h);
end