function [M] = import_text_file( filename )
format = '%u %u %f\n';
fileID = fopen(filename,'r');
v = fscanf( fileID, format,  [3 Inf] );
v = v';
M = sparse( v(:,1)+1, v(:,2)+1, v(:,3) );
end