function varargout = import_from_file(filename,defaultExt,readDataFcn,verbose)
if(nargin<4)
    verbose = false;
end
[varargout{1:nargout}] = open_file(filename,defaultExt,'r',readDataFcn,verbose);
end