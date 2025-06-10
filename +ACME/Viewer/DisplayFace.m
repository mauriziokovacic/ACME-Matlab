function [h] = DisplayFace(h,CData)
if((nargin<2)||isempty(CData))
    CData = ones(1,3);
end
h.Marker    = 'none';
h.EdgeColor = 'none';
DisplayColor(h,CData);
end