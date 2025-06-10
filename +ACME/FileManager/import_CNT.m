function [P, varargout] = import_CNT( filename )
formatP = 'v %f %f %f\n';
formatN = 'n %f %f %f\n';
formatW = 'w %u %u %f\n';
formatD = 'd %f\n';
formatA = 'a %f\n';
formatI = 'f %f\n';
fileID = fopen(strcat(filename,'.cnt'),'r');
P  = fscanf( fileID, formatP,  [3 Inf] )';

if( nargout >= 2)
varargout{1} = fscanf( fileID, formatN,  [3 Inf] )';
end

if( nargout >= 3 )
T  = fscanf( fileID, formatW,  [3 Inf] )';
T(:,1) = T(:,1)+1;
T(:,2) = T(:,2)+1;
varargout{2} = sparse( T(:,1), T(:,2), T(:,3), max(T(:,1)), max(T(:,2)) );
end

if( nargout >= 4 )
varargout{3} = fscanf( fileID, formatD,  [1 Inf] )';
end

if( nargout >= 5 )
varargout{4} = fscanf( fileID, formatA,  [1 Inf] )';
end

if( nargout >= 6 )
varargout{5} = fscanf( fileID, formatI,  [1 Inf] )';
end

fclose(fileID);

end