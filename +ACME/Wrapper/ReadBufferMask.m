function [CData] = ReadBufferMask(h)
if(nargin==0)
    h = handle(gcf);
end
    function [Data] = readDataFcn(fig,~,p)
        for i = 1 : numel(p)
            p(i).FaceLighting    = 'none';
            p(i).FaceColor       = 'interp';
            p(i).FaceVertexCData = zeros(size(p(i).Vertices));
        end
        Data = getframe(fig);
        Data = ~logical(sum(double(Data.cdata),3));
    end
CData = ReadBuffer(h,@readDataFcn);
end