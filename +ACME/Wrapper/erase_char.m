function [txt] = erase_char(txt,char)
txt = strrep(txt,char,'');
end