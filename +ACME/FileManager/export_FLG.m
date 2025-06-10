function export_FLG(filename,V,H,E,F)
if( nargin < 5 )
    F = [];
end
if( nargin < 4 )
    E = [];
end
if( nargin < 3 )
    H = [];
end
if( nargin < 2 )
    V = [];
end
formatV = 'v %u\n';
formatH = 'h %u\n';
formatE = 'e %u\n';
formatF = 'f %u\n';
fileID = fopen( strcat(filename,'.flg'), 'wt');
if( ~isempty(V) )
    fprintf( fileID, formatV, V' );
end
if( ~isempty(H) )
    fprintf( fileID, formatH, H' );
end
if( ~isempty(E) )
    fprintf( fileID, formatE, E' );
end
if( ~isempty(F) )
    fprintf( fileID, formatF, F' );
end
fclose(fileID);
end