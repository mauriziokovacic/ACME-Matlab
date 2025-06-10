function [h] = DisplayWired(h,FaceColor,EdgeColor)
if((nargin<3)||isempty(EdgeColor))
    EdgeColor = zeros(1,3);
end
if((nargin<2)||isempty(FaceColor))
    FaceColor = ones(1,3);
end
h.Marker    = 'none';
h.FaceColor = FaceColor;
h.EdgeColor = EdgeColor;
end