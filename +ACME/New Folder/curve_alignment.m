function [T] = curve_alignment(C,n,varargin)
T = repmat(linspace(0,1,n),numel(C),1);
f = [0.9 0.6 0.3 0 -0.3 -0.6 -0.9];
e = [4 1; 4 2; 4 3; 4 5; 4 6; 4 7];
for k = 1 : row(e)
    i = e(k,1);
    j = e(k,2);
    T(j,:) = march(C(i),C(j),f(i),f(j),T(i,:),varargin{:});
end
end


function [T] = march(Ci, Cj, fi, fj, t, varargin)
P = fetchData(Ci, {'Point'},t, varargin{:});
T = curvemap(P,Cj);
end

function [T] = curvemap(P, C)
[A,B] = C.segment();
t     = C.parameter();
t     = [t(1:end-1) t(2:end)];
T     = zeros(1,row(P));
for i = 1 : row(P)
    [Q,a] = project_point_on_segment(A,B,P(i,:));
    j     = min_index(distance(Q,P(i,:),2));
    T(i)  = (1-a(j)) * t(j,1) + a(j) * t(j,2);
end
end