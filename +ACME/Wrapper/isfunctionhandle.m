function [tf] = isfunctionhandle(h)
    tf = arrayfun(@(hh) isa(hh,'function_handle'),h);
end