function [h] = DisplayWireframe(h,CData)
h.Marker    = 'none';
h.FaceColor = 'none';
if( nargin < 2 )
    if( row(h.CData) == row(h.Vertices) )
        h.EdgeColor = 'interp';
    else
        h.EdgeColor = [0 0 0];
    end
else
    if(isempty(CData))
        CData = [0 0 0];
    end
    h.EdgeColor = CData;
end
end