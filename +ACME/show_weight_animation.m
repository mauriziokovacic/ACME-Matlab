function [T] = show_weight_animation(Mesh,Skin,t)
if(nargin<3)
    t = 1;
end

CreateViewer3D('right');
h = Mesh.show(zeros(row(Mesh.Vertex),1));
cmap('king',256);
colorbar;
caxis([0 1]);

helper();

T = timer();
T.Period = t;
T.TimerFcn = @(o,e) helper(h,Skin.Weight);
T.ExecutionMode = 'fixedDelay';
T.start();
end

function helper(h,W)
persistent i;
if(isempty(i))
    i = 1;
end
if(nargin==0)
    i = 1;
    return;
end
ax = ancestor(h,'axes');
ax.Title.String = ['Weight ',num2str(i)];
h.FaceVertexCData = full(W(:,i));
i = mod(i,col(W))+1;
end