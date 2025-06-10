function [PData] = ReadBufferPosition(h,Min,Max)
n = nargin;
if(nargin==0)
    h = handle(gcf);
end
    function [Data] = readDataFcn(fig,ax,p)
        if(n<3||isempty(Max))
            Max = [max(ax.XLim) max(ax.YLim) max(ax.ZLim)];
        end
        if(n<2||isempty(Min))
            Min = [min(ax.XLim) min(ax.YLim) min(ax.ZLim)];
        end
        for i = 1 : numel(p)
            p(i).FaceLighting    = 'none';
            p(i).FaceColor       = 'interp';
            p(i).FaceVertexCData = position2color(p(i).Vertices,Min,Max);
        end
        Data = getframe(fig);
        Data = Data.cdata;
        Data = color2position(Data,Min,Max);
    end
PData = ReadBuffer(h,@readDataFcn);
end