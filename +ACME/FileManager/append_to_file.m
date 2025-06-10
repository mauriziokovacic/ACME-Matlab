function varargout = append_to_file(filename,defaultExt,writeDataFcn,verbose)
if(nargin<4)
    verbose = false;
end
[varargout{1:nargout}] = open_file(filename,defaultExt,'a',writeDataFcn,verbose);
end