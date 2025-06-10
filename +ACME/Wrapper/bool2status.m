function [str] = bool2status(tf,postfix)
if(nargin<2)
    postfix = '';
end
if(tf)
    str='Enable';
else
    str='Disable';
end
str = strcat(str,postfix);
end