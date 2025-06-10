function [ P, UV, N, T, varargout ] = import_GEO( filename )
formatP  = 'p %f %f %f\n';
formatN  = 'n %f %f %f\n';
formatUV = 'uv %f %f\n';
formatT  = 't %u %u %u\n';
formatV  = 'v %u %u\n'; %id h
formatH  = 'h %u %u %u %u %u\n'; %id v f next prev
formatE  = 'e %u\n'; %h
formatF  = 'f %u %u\n'; %id h

fileID = fopen(strcat(filename,'.geo'),'r');
P  = fscanf( fileID, formatP,  [3 Inf] )';
UV = fscanf( fileID, formatUV, [2 Inf] )';
N  = fscanf( fileID, formatN,  [3 Inf] )';
fscanf( fileID, formatE,  [2 Inf] )'; % comment this
T  = fscanf( fileID, formatT,  [3 Inf] )';
if( nargout >= 5 )
    varargout{1} = fscanf( fileID, formatV,  [2 Inf] )';
end
if( nargout >= 6 )
    varargout{2} = fscanf( fileID, formatH,  [5 Inf] )';
end
if( nargout >= 7 )
    varargout{3} = fscanf( fileID, formatE,  [1 Inf] )'*2;
end
if( nargout >= 8 )
    varargout{4} = fscanf( fileID, formatF,  [2 Inf] )';
end
if( nargout > 4 )
    for i = nargout-4 : nargout
        varargout{i}(varargout{i}==intmax('uint32')) = -1;
        varargout{i} = varargout{i}+1;
    end
end

fclose(fileID);
end