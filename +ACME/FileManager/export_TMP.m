function export_TMP( filename, format, data )
fileID = fopen([filename,'.tmp'],'wt');
for i = 1 : numel(data)
    fprintf( fileID, format{i}, data{i}' );
end
fclose(fileID);
end