function export_RGN( filename, RData )
formatR = 'r %u %u\n';
formatW = 'w %u %u\n';
[i,j] = find(RData.I);
R     = [j i]-1;
fileID = fopen(strcat(filename,'.rgn'),'wt');
fprintf( fileID, formatR, R' );
fprintf( fileID, formatW, ([(1:col(RData.I))' RData.W']-1)' );
fclose(fileID);
end