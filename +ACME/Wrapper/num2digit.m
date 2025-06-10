function [out] = num2digit(x, precision)
if(nargin < 2)
    precision = 32;
end
digits(precision+10);
out = strrep(char(vpa(x)), '.', '');
out = arrayfun(@(c) str2double(c), out);
%out = str2double(regexp(char(vpa(x)),'\d','match'));
out = out(1:precision);
digits(32);
end