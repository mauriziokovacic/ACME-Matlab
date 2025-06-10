function [IData] = ReadBufferFaceIndex(h)
    function [Data] = readDataFcn(fig,~,p)
        for i = 1 : numel(p)
            p(i).FaceLighting    = 'none';
            p(i).FaceColor       = 'flat';
            p(i).FaceVertexCData = index2color((1:row(p(i).Faces))');
        end
        Data = getframe(fig);
        Data = Data.cdata;
    end
IData = ReadBuffer(h,@readDataFcn);
end