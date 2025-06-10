function export_FLD( filename, F, G, D )
formatF = 'f %f\n';
formatG = 'g %f %f %f\n';
formatD = 'd %f\n';
fileID = fopen(strcat(filename,'.fld'),'wt');
fprintf( fileID, formatF, F' );
fprintf( fileID, formatG, G' );
fprintf( fileID, formatD, D' );
fclose(fileID);
end