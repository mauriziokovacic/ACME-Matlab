function [M] = disk_mask(radius)
M = strel('disk',radius,0);
M = M.Neighborhood;
end