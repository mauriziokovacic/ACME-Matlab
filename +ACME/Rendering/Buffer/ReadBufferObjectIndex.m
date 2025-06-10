function [IData] = ReadBufferObjectIndex(h,MData)
if((nargin<2)||isempty(MData))
    MData = ReadBufferMask(h);
end
    function [Data] = readDataFcn(fig,~,p)
        for i = 1 : numel(p)
            p(i).FaceLighting = 'none';
            p(i).FaceColor    = index2color(i);
        end
        Data = getframe(fig);
        Data = MData .* double(color2index(Data.cdata));
    end
IData = ReadBuffer(h,@readDataFcn,{'FaceLighting','FaceColor'});
end