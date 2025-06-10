function [tf] = ismenu(h)
    tf = arrayfun(@(hh) isa(hh,'matlab.ui.container.Menu'),h);
end