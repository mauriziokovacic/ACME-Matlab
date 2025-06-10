function [varargout] = chrono(varargin)
if( isa(varargin{1},'Chronometer') )
    fun = varargin{2};
    varargin{1}.start_clock(func2str(fun));
    [varargout{1:nargout}] = fun(varargin{3:end});
    varargin{1}.stop_clock(func2str(fun));
else
    tic
    [varargout{1:nargout}] = varargin{1}(varargin{2:end});
    toc
end
end