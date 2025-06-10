function [P] = containerCorner(h,type)
expectedValues = {'topleft','topright','bottomleft','bottomright'};
parser = inputParser;
addRequired(parser,'h',@(data) isprop(data,'Position'));
addOptional(parser,'type', expectedValues{3}, @(data) any(validatestring(data,expectedValues)))
parse(parser,h,type);
p = h.Position(1:2);
d = h.Position(3:4);
f = [0 0];
if(strcmpi(type,'topLeft'))
    f = [0 1];
end
if(strcmpi(type,'topRight'))
    f = [1 1];
end
if(strcmpi(type,'bottomRight'))
    f = [1 0];
end
P = p+d.*f;
end