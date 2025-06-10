function [h] = DisplayPoints(h,CData)
if((nargin<2)||isempty(CData)||row(CData)>1)
    CData = zeros(1,3);
end
h.FaceColor       = 'none';
h.EdgeColor       = 'none';
h.Marker          = '.';
h.MarkerEdgeColor = CData;
h.MarkerFaceColor = CData;
h.MarkerSize      = mesh_scale(h.Vertices) / 100;
end