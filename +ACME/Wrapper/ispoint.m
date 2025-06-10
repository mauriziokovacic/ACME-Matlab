function [tf] = ispoint(h)
    tf = arrayfun(@(hh) isa(hh,'matlab.graphics.chart.primitive.Scatter'),h);
end