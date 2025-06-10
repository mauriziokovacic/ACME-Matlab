function [h] = get_light(h)
h = get_handle(get_axes(h),@islight);
end


