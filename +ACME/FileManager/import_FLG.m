function [V,varargout] = import_FLG( filename )
formatV = 'v %u\n';
formatH = 'h %u\n';
formatE = 'e %u\n';
formatF = 'f %u\n';
fileID = fopen( strcat(filename,'.flg'), 'r' );
V = fscanf(fileID,formatV,[1 Inf])';
if( nargout >= 2 )
varargout{1} = fscanf(fileID,formatH,[1 Inf])';
end
if( nargout >= 3 )
varargout{2} = fscanf(fileID,formatE,[1 Inf])';
end
if( nargout >= 4 )
varargout{3} = fscanf(fileID,formatF,[1 Inf])';
end
fclose(fileID);
end