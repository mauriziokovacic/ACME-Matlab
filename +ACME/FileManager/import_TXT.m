function [text] = import_TXT(filename)
fileID = fopen(filename, 'r');
text   = textscan(fileID,'%s','Delimiter',newline);
fclose(fileID);
end