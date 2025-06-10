function matrix2file(filename,M)
    if( strcmpi(class(M),'double'))
        format = repmat('%f ',1,size(M,2));
    else
        format = repmat('%u, ',1,size(M,2));
    end
    fileID = fopen(strcat(filename,'.txt'),'w');
    fprintf( fileID, format, M' );
    fclose(fileID);
end