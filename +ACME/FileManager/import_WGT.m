function [ W ] = import_WGT( filename )
formatT  = '%u %u %f\n';
fileID = fopen(strcat(filename,'.wgt'),'r');
T  = fscanf( fileID, formatT,  [3 Inf] )';
T  = [T(:,1)+1, T(:,2)+1, T(:,3)];
W  = sparse( T(:,1), T(:,2), T(:,3), max(T(:,1)), max(T(:,2)) );
fclose(fileID);
end