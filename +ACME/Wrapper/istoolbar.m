function [tf] = istoolbar(h)
    tf = arrayfun(@(hh) isa(hh,'matlab.ui.container.Toolbar'),h);
end