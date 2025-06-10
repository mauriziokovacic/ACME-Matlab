function export_SGM( filename, SData )
formatN = 'n %u\n';
formatS = 's %u %u %f %f %f %f\n';
S = [];
for s = 1 : row(SData)
    if(isempty(SData{s}))
        continue;
    end
    I = repmat(s-1,row(SData{s}.A),1);
    A = SData{s}.A(:,1:2);
    B = SData{s}.B(:,1:2);
    T = SData{s}.T-1;
    S = [S; I T A B];
end
fileID = fopen(strcat(filename,'.sgm'),'wt');
fprintf( fileID, formatN, row(SData) );
fprintf( fileID, formatS, S' );
fclose(fileID);
end