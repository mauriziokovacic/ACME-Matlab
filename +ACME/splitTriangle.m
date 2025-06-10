function [P,T,varargout] = splitTriangle(P,T,triIndex,varargin)
if((nargin<3)||isempty(triIndex))
    triIndex = (1:row(T))';
end
n = row(P);
m = numel(triIndex);
[I,J,K] = tri2ind(T(triIndex,:));
P  = [P; [P(I,:)+P(J,:);P(J,:)+P(K,:);P(K,:)+P(I,:)]/2];
for i = 1 : (nargout-2)
    X = varargin{i};
    X  = [X; [X(I,:)+X(J,:);X(J,:)+X(K,:);X(K,:)+X(I,:)]/2];
    varargout{i} = X;
end
Ei = n+0*m+(1:m)';
Ej = n+1*m+(1:m)';
Ek = n+2*m+(1:m)';
T = [T(setdiff((1:row(T))',triIndex),:);...
     I Ei Ek;...
     J Ej Ei;...
     K Ek Ej;...
     Ei Ej Ek];
end