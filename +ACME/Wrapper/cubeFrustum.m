function cubeFrustum(ax)
if(nargin==0)
    ax = handle(gca);
end
C   = ax.CameraTarget;
Min = frustumEndpoint(ax,1);
Max = frustumEndpoint(ax,2);
d   = distance(Min,Max)/2;
setFrustum(ax,C-d,C+d);
end