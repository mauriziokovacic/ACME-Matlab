function [LData] = ReadBufferLight(h)
    function [Data] = readDataFcn(fig,~,p)
        for i = 1 : numel(p)
            p(i).FaceColor = [1 1 1];
        end
        Data = getframe(fig);
        Data = color2double(Data.cdata(:,:,1));
    end
LData = ReadBuffer(h,@readDataFcn,{'FaceColor','FaceVertexCData'});
end