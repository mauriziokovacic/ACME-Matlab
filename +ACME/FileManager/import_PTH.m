function [T,B,E,varargout]=import_PTH( filename )
formatB = 'b %u %f %f %f %f %f %f\n';
formatE = 'e %u %u\n';
fileID = fopen(strcat(filename,'.pth'),'r');
B = fscanf( fileID, formatB,  [7 Inf] )';
E = fscanf( fileID, formatE,  [2 Inf] )';
T = B(:,1)+1;
if( nargout >= 4 )
    varargout{1} = B(:,5:7);
end
B = B(:,2:4);
fclose(fileID);
end