function [txt] = capital(txt)
txt = strcat(upper(txt(1)),lower(txt(2:end)));
end