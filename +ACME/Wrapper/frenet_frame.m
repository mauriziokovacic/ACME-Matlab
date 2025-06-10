function [T,N,B] = frenet_frame(P,E,varargin)
code = @(i) base2dec(num2str(i,'%u%u%u'),2);
if( nargin < 5 )
    B = [];
else
    B = varargin{3};
end
if( nargin < 4 )
    N = [];
else
    N = varargin{2};
end
if( nargin < 3 )
    T = [];
else
    T = varargin{1};
end
if( nargin < 2 )
    E = [];
end
if( isempty(E) )
    E = [(1:row(P))' [(2:row(P))';1]];
end
id = unique(E);
A = zeros(row(P),3);
for i = 1 : numel(id)
    c  = id(i);
    n  = E(c==E(:,1),2);
    if( isempty(n) )
        n = c;
    end
    p  = E(c==E(:,2),1);
    if( isempty(p) )
        p = c;
    end
    A(id(i),:) = [p c n];
end

i = code([~isempty(B) ~isempty(N) ~isempty(T)]);

switch(i)
    case 0
        T = P(A(id,3),:)-P(A(id,1),:);
        N = T(A(id,3),:)-T(A(id,1),:);
        B = cross(T,N,2);
    case 1
        N = T(A(id,3),:)-T(A(id,1),:);
        B = cross(T(id,:),N,2);
    case 2
        B = N(A(id,3),:)-N(A(id,1),:);
        T = cross(N(id,:),B,2);
    case 3
        B = cross(T(id,:),N(id,:),2);
    case 4
        T = P(A(id,3),:)-P(A(id,1),:);
        N = cross(T,B(id,:),2);
    case 5
        N = cross(T(id,:),B(id,:),2);
    case 6
        T = cross(N(id,:),B(id,:),2);
end
T = normr(T);
N = normr(N);
B = normr(B);

end