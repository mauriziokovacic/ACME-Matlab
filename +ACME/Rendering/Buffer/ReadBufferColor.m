function [CData] = ReadBufferColor(h)
    function [Data] = readDataFcn(fig,~,p)
        for i = 1 : numel(p)
            p(i).FaceLighting = 'none';
            Data = getframe(fig);
            Data = color2double(Data.cdata);
        end
    end
CData = ReadBuffer(h,@readDataFcn,{'FaceLighting'});
end