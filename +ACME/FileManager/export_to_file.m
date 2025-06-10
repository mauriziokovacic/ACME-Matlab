function varargout = export_to_file(filename,defaultExt,writeDataFcn,verbose)
if(nargin<4)
    verbose = false;
end
[varargout{1:nargout}] = open_file(filename,defaultExt,'wt',writeDataFcn,verbose);
end