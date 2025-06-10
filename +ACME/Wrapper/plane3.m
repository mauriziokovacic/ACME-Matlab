function [h] = plane3(Position,Orientation,Side,CData,varargin)
if(nargin<4)
    CData = [1 1 0];
end
if(nargin<3)
    Side = 1;
end
if(row(Position)==1)
    Position = repmat(Position,row(Orientation),1);
end
if(row(Orientation)==1)
    Orientation = repmat(Orientation,row(Position),1);
end
Q     = reshape((1:row(Position)*4),4,row(Position))';
PData = repmat(Side .* [-0.5 -0.5 0; 0.5 -0.5 0; 0.5 0.5 0; -0.5 0.5 0],1,1);%row(Position),1);
NData = repmat([0 0 1],1,1);%row(Position),1);
if( col(CData)==4 )
    AData = CData(:,4);
    CData = CData(:,1:3);
else
    AData = 1;
end

PP = [];
NN = [];
for i = 1 : row(Position)
    axis  = cross(NData,Orientation(i,:),2);
    angle = acos(dot(NData,normr(Orientation(i,:)),2));
    if(angle>0)
        R = axang2rotm([axis,angle]);
    else
        R = eye(3);
    end
    P = zeros(4,3);
    N = zeros(4,3);
    for j = 1 : 4
        P(j,:) = (R * PData(j,:)')';
        N(j,:) = (R * [0;0;1])';
    end
    PP = [PP;P+Position(i,:)];
    NN = [NN;N];
%     PData(i:i+3,:) = P(:,1:3);
%     NData(i:i+3,:) = N(:,1:3);
end
h = patch('Faces',               Q,...
          'Vertices',            PP,...
          'VertexNormals' ,      NN,...
          'FaceColor',           'flat',...
          'FaceVertexCData',     CData,...
          'FaceLighting',        'none',...
          'EdgeColor',           'k',...
          'FaceAlpha',           'flat',...
          'FaceVertexAlphaData', AData,...
          varargin{:});

end