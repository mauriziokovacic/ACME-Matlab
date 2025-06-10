function [h] = DisplayTransparent(h,AData)
switch row(AData)
    case 1
        h.FaceAlpha           = AData;
    case row(h.Faces)
        h.FaceVertexAlphaData = AData;
        h.FaceAlpha           = 'flat';
    case row(h.Vertices)
        h.FaceVertexAlphaData = AData;
        h.FaceAlpha           = 'interp';
    otherwise
        disp('Wrong data dimension');
end
end