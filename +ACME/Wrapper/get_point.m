function [h] = get_point(h)
h = get_handle(get_axes(h),@ispoint);
end