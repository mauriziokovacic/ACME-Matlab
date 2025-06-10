function [Min,Max] = get_clippig_bounding_box(ax)
Min = [ax.XLim(1) ax.YLim(1) ax.ZLim(1)];
Max = [ax.XLim(2) ax.YLim(2) ax.ZLim(2)];
end