function [varargout] = import_TMP( filename, format, size )
fileID = fopen([filename,'.tmp'],'r');
for i = 1 : numel(format)
    varargout{i} = fscanf( fileID, format{i}, [size Inf] )';
end
fclose(fileID);
end