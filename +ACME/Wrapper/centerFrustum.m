function centerFrustum(ax)
if(nargin<1)
    ax = handle(gca);
end
h = get_patch(ax);
if(~iscell(h))
    h = arrayfun(@(hh) hh, h, 'UniformOutput',false);
end
m = cell2mat(cellfun(@(hh) min(hh.Vertices,[],1),h,'UniformOutput',false));
M = cell2mat(cellfun(@(hh) max(hh.Vertices,[],1),h,'UniformOutput',false));
set(ax,'XLim',[m(1) M(1)],'YLim',[m(2) M(2)],'ZLim', [m(3) M(3)]);
cubeFrustum();
end