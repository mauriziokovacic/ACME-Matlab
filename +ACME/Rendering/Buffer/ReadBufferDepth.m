function [DData] = ReadBufferDepth(h,nearClip,farClip,MData)
if((nargin<4)||isempty(MData))
    MData = ReadBufferMask(h);
end
if(nargin<3)
    farClip = 1000;
end
if(nargin<2)
    nearClip = 0.01;
end
if(nargin<1)
    h = handle(gcf);
end
    function [Data] = readDataFcn(fig,ax,p)
        X    = campos(ax);
        for i = 1 : numel(p)
            p(i).FaceLighting    = 'none';
            p(i).FaceColor       = 'interp';
            p(i).FaceVertexCData = repmat(normalize(...
                                              clamp(distance(p(i).Vertices,X),...
                                                    nearClip,...
                                                    farClip)),...
                                          1,3);
        end
        Data = getframe(fig);
        Data = (MData).*double(Data.cdata(:,:,1))/255+(~MData);
    end
DData = ReadBuffer(h,@readDataFcn);
end