function [d] = DepthData(ax)
h = get_patch(ax);
X = campos(ax);
P = h.Vertices;
C = [repmat(repelem(ax.ZLim',4,1),1,1),...
     repmat(repelem(ax.YLim',2,1),2,1),...
     repmat(repelem(ax.ZLim',1,1),4,1)];
d = vecnorm3(X-C);
d = normalize(vecnorm3(P-X),min(d),max(d));
end