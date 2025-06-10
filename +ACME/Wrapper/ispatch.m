function [tf] = ispatch(h)
    tf = arrayfun(@(hh) isa(hh,'matlab.graphics.primitive.Patch'),h);
end