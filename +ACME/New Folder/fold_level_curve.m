function [C] = fold_level_curve(M, S, D, n, iso)
if( nargin < 5 )
    iso = [];
end
if( nargin < 4 )
    n = 7;
end
n = n+mod(n-1,2);
if(isempty(iso))
    iso = fold_isovalues(D,n);
else
    iso = linspace(-iso,iso,n);
end
iso(abs(iso)<0.0001) = 0;
C = [];
for i = 1 : n
    C = [C;SurfaceCurve.createFromField(M,D,iso(i))];
end
C = arrayfun(@(c) OrientedCurve('Point',  c.surfacePoint(),...
                                'Edge',   c.Edge,...
                                'Normal', c.surfaceNormal(),...
                                'Weight', c.surfaceData(S.Weight)), C);
end