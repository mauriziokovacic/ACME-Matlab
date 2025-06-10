function [M] = modelTransform(ax)
x = ax.XLim;
y = ax.YLim;
z = ax.ZLim;
s = 1./diff([x;y;z],1,2);
M = [s(1), 0,    0,    -x(1)*s(1); ...
     0,    s(2), 0,    -y(1)*s(2); ...
     0,    0,    s(3), -z(1)*s(3); ...
     0,    0,    0,     1];
end