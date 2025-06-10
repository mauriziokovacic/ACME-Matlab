function [ C ] = import_COR( filename )
formatC  = '%f %f %f\n';
fileID = fopen(strcat(filename,'.cor'),'r');
C  = fscanf( fileID, formatC,  [3 Inf] )';
fclose(fileID);
end