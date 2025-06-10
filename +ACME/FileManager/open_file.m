function varargout = open_file(filename,defaultExt,permission,fileDataFcn,verbose)
if(nargin<5)
    verbose = false;
end
[path,filename,ext] = fileparts(filename);
if(isempty(ext)||~strcmpi(ext(2:end),defaultExt))
    ext = ['.',defaultExt];
end
debug_message(['Opening file "',...
               strrep(path,'\','\\'),...
               strrep(filesep,'\','\\'),...
               filename,ext,'"...'],verbose);
fileID = fopen([path,filesep,filename,ext],permission);
if(fileID==-1)
    ext = ['.',upper(defaultExt)];
    debug_message(['Opening file "',...
                   strrep(path,'\','\\'),...
                   strrep(filesep,'\','\\'),...
                   filename,ext,'"...'],verbose);
    fileID = fopen([path,filesep,filename,ext],permission);
    if(fileID==-1)
        debug_message(['FAILED.',newline],verbose);
        error('Could not open the file.');
    end
end
debug_message(['DONE.',newline],verbose);
debug_message(['Starting routine...',newline],verbose);
% if(nargout>0)
    [varargout{1:nargout}] = fileDataFcn(fileID);
% else
%     fileDataFcn(fileID);
% end
debug_message(['Routine COMPLETED.',newline],verbose);
debug_message('Closing file...',verbose);
fclose(fileID);
debug_message(['COMPLETED.',newline],verbose);
end