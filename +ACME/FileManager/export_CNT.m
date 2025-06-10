function export_CNT( filename, P, N, W, varargin )
formatP = 'v %f %f %f\n';
formatN = 'n %f %f %f\n';
formatW = 'w %u %u %f\n';
formatD = 'd %f\n';
formatA = 'a %f\n';
formatI = 'f %f\n';
formatC = 'c %f %f %f\n';

[i,j,w] = find(W);

fileID = fopen( strcat(filename,'.cnt'), 'wt' );
fprintf( fileID, formatP, P' );
fprintf( fileID, formatN, N' );
fprintf( fileID, formatW, [i-1 j-1 w]' );
if( nargin >= 5 )
    fprintf( fileID, formatD, varargin{1}' );
end
if( nargin >= 6 )
    fprintf( fileID, formatA, varargin{2}' );
end
if( nargin >= 7 )
    fprintf( fileID, formatI, varargin{3}' );
end
if( nargin >= 8 )
    fprintf( fileID, formatC, varargin{4}' );
end
fclose(fileID);
end