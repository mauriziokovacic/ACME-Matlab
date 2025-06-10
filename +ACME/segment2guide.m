function [G] = segment2guide(P,N,UV,T,W,S)
if(iscell(S))
    [Sa,Sb,I,h]        = gather(S);
else
    Sa = S.A;
    Sb = S.B;
    I  = S.T;
    h  = zeros(row(Sa),1);
end
[P,N,UV,W,B,T,h,E] = segment(P,N,UV,T,W,Sa,Sb,I,h);
G                  = merge(P,N,UV,W,B,T,h,E);
end

function [A,B,I,h] = gather(S)
A = [];
B = [];
I = [];
h = [];
for i = 1  : row(S)
    if(isempty(S{i}))
        continue;
    end
    A = [A;S{i}.A];
    B = [B;S{i}.B];
    I = [I;S{i}.T];
    h = [h;repmat(i,row(S{i}.T),1)];
end
end

function [P,N,UV,W,B,T,h,E] = segment(P,N,UV,T,W,Sa,Sb,I,h)
P  = interleave(from_barycentric( P,T,I,Sa),from_barycentric( P,T,I,Sb));
N  = interleave(from_barycentric( N,T,I,Sa),from_barycentric( N,T,I,Sb));
UV = interleave(from_barycentric(UV,T,I,Sa),from_barycentric(UV,T,I,Sb));
W  = interleave(from_barycentric( W,T,I,Sa),from_barycentric( W,T,I,Sb));
B  = interleave(Sa,Sb);
T  = interleave(I,I);
h  = interleave(h,h);
E  = reshape(1:row(P),2,floor(row(P)/2))';
[P,i,j] = uniquetol(P,0.0001,'ByRows',true);
N  =  N(i,:);
UV = UV(i,:);
W  =  W(i,:);
B  =  B(i,:);
T  =  T(i,:);
h  =  h(i,:);
E  =  j(E);
end

function [P,N,UV,W,E] = split(P,N,UV,W,E)
n  = row(P);
e  = row(E);
P  = [ P;0.5 .* ( P(E(:,1),:)+ P(E(:,2),:))];
N  = [ N;0.5 .* ( N(E(:,1),:)+ N(E(:,2),:))];
UV = [UV;0.5 .* (UV(E(:,1),:)+UV(E(:,2),:))];
W  = [ W;0.5 .* ( W(E(:,1),:)+ W(E(:,2),:))];
E  = [E(:,1) (n+1:n+e)'; (n+1:n+e)' E(:,2)];
end

function [G] = merge(P,N,UV,W,B,T,h,E)
G.P  = P;
G.N  = N;
G.UV = UV;
G.W  = W;
G.B  = B;
G.I  = T;
G.h  = h;
G.E  = E;
G.U = normr(accumarray3([E(:,1);E(:,2)],repmat(P(E(:,2),:)-P(E(:,1),:),2,1),[row(P),1]));
G.T  = [E E(:,1)];
end