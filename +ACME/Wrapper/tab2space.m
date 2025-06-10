function [txt] = tab2space(txt)
txt = strrep(txt,'\t','    ');
end