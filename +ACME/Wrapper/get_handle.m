function [h] = get_handle(h,func)
h = get(h,'Children');
if( iscell(h) )
    h = cellfun(@(hh) hh(func(hh)), h,'UniformOutput',false);
    h = vertcat(h{:});
else
    h = h(func(h));
end
end