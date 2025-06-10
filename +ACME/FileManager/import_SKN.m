function [ W, varargout ] = import_SKN( filename )
formatT  = 'w %u %u %f\n';
formatF  = 'f %f %f %f\n';
formatFS = 's %u %u %u\n';
formatD  = 'd %f %f %f\n';
formatP  = 'p %f %f %f\n';
fileID = fopen(strcat(filename,'.skn'),'rt');
T  = fscanf( fileID, formatT,  [3 Inf] )';
W  = sparse( T(:,1), T(:,2), T(:,3), max(T(:,1)), max(T(:,2)) );

if( nargout >= 2 )
    varargout{1} = fscanf( fileID, formatF,  [3 Inf] )';
end
if( nargout >= 3 )
    T = fscanf( fileID, formatFS, [3 Inf] )' + 1;
    tmp{1} = sort(T(T(:,1)==1,2:3),2);
    tmp{2} = sort(T(T(:,1)==2,2:3),2);
    tmp{3} = sort(T(T(:,1)==3,2:3),2);
    varargout{2} = tmp;%fscanf( fileID, formatFS, [2 Inf] )' + 1;
end
if( nargout >= 4 )
    varargout{3} = fscanf( fileID, formatD,  [3 Inf] )';
end
if( nargout >= 5 )
    varargout{4} = fscanf( fileID, formatP,  [3 Inf] )';
end
fclose(fileID);
end