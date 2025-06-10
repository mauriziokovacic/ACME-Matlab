function [Wv,Wf] = import_CAGE( filename )
Wv = [];
Wf = [];
formatV = 'v %u %u %f\n';
formatF = 'f %u %u %f\n';
fileID = fopen(strcat(filename,'.cage'),'r');
T = fscanf( fileID, formatV, [3 Inf] )';
Wv = sparse( T(:,1)+1, T(:,2)+1, T(:,3), max(T(:,1))+1, max(T(:,2))+1 );

T = fscanf( fileID, formatF, [3 Inf] )';
if( ~isempty(T) )
Wf = sparse( T(:,1)+1, T(:,2)+1, T(:,3), max(T(:,1))+1, max(T(:,2))+1 );
end
fclose(fileID);
end