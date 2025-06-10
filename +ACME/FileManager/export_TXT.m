function export_TXT(filename,text)
fileID = fopen(filename, 'wt');
fprintf(fileID,'%c',text);
fclose(fileID);
end