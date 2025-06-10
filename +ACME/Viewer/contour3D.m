function [h] = contour3D(P,T,F,n,varargin)
A = [];
B = [];
I = [];
if(nargin<4)
    n = 10;
end
f = [min(F) max(F)];
for i = 1 : n-1
    iso = f(1) + i/n * (f(2)-f(1));
    C = meandering_triangle(T,F,iso);
    if(~isempty(C))
        C = C{1};
        A = [A;C.A];
        B = [B;C.B];
        I = [I;C.T];
    end
end
Q = interleave(from_barycentric(P,T,I,A),from_barycentric(P,T,I,B));
E = reshape((1:row(Q))',2,row(A))';
h = display_curve(Q,E,'EdgeColor','k','FaceColor','none','LineWidth',0.25,varargin{:});

% h = [];
% for i = 1 : n-1
%     f = i/n;
%     C = meandering_triangle(T,F,i/n);
%     if(~isempty(C))
%         C = C{1};
%         A = C.A;
%         B = C.B;
%         I = C.T;
%         Q = interleave(from_barycentric(P,T,I,A),from_barycentric(P,T,I,B));
%         E = reshape((1:row(Q))',2,row(A))';
%         h = [h;display_curve(Q,E,'EdgeColor','k','FaceColor','none','LineWidth',0.25,'UserData',f,varargin{:})];
%     end
% end

end