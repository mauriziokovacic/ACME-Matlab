function [I] = import_vertex_list( filename )
format = '%u\n';
fileID = fopen(strcat(filename,'.vertex'),'r');
I = fscanf( fileID, format,  [1 Inf] );
I = I' + 1;
end