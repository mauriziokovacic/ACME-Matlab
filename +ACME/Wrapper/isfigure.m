function [tf] = isfigure(h)
    tf = arrayfun(@(hh) isa(hh,'matlab.ui.Figure'),h);
end