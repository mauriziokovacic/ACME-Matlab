function setFrustumEndPoint(ax,P,ind)
if(nargin<3)
    ind = 1;
end
if(isempty(ind)||~ismember(ind,[1 2]))
    error('Index should be either 1 or 2');
end
ax.XLim(ind) = P(1);
ax.YLim(ind) = P(2);
ax.ZLim(ind) = P(3);
end