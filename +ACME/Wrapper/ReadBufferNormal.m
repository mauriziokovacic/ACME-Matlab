function [NData] = ReadBufferNormal(h)
    function [Data] = readDataFcn(fig,~,p)
        for i = 1 : numel(p)
            p(i).FaceLighting    = 'none';
            p(i).FaceColor       = 'interp';
            p(i).FaceVertexCData = normal2color(p(i).VertexNormals);
        end
        Data = getframe(fig);
        Data = Data.cdata;
        Data = color2normal(Data);
    end
NData = ReadBuffer(h,@readDataFcn);
end