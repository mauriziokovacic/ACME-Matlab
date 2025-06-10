function CPSOperatorViewerSlice( V, row )
cla;
res = size(V,1);
k = floor(row * (res-1) + 1);
Im = squeeze(V(k,:,:));
imshow(Im);
end