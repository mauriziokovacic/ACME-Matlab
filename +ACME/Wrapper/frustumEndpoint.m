function [P] = frustumEndpoint(ax,ind)
if(nargin<2)
    ind = 1;
end
if(isempty(ind)||~ismember(ind,[1 2]))
    error('Index should be either 1 or 2');
end
P = [ax.XLim(ind) ax.YLim(ind) ax.ZLim(ind)];
end