function [F,varargout] = import_FLD( filename )
formatF = 'f %f\n';
formatG = 'g %f %f %f\n';
formatD = 'd %f\n';
fileID = fopen(strcat(filename,'.fld'),'r');
F = fscanf( fileID, formatF,  [1 Inf] )';
if( nargout >= 2 )
varargout{1} = fscanf( fileID, formatG,  [3 Inf] )';
end
if( nargout >= 3 )
varargout{2} = fscanf( fileID, formatD,  [1 Inf] )';
end
fclose(fileID);
end