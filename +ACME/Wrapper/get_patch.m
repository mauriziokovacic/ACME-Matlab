function [h] = get_patch(h)
h = get_handle(get_axes(h),@ispatch);
end