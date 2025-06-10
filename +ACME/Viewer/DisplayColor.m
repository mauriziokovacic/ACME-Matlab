function [h] = DisplayColor(h,CData)
switch row(CData)
    case 1
        h.FaceColor       = CData;
    case row(h.Faces)
        h.FaceVertexCData = CData;
        h.FaceColor       = 'flat';
    case row(h.Vertices)
        h.FaceVertexCData = CData;
        h.FaceColor       = 'interp';
    otherwise
        disp('Wrong data dimension');
end
end