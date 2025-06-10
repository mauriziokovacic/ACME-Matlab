function [C] = compute_OptimizedCoR(P,T,W)
Wi = W;
% for i = 1 : 5
%     [P,T,W] = SubdivideFcn(P,T,W);
% end
[C] = compute(Wi,P,T,W);
end

function [P,T,W] = SubdivideFcn(P,T,W,eps)
if(nargin<4)
    eps = 0.1;
end
[I,J,K] = tri2ind(T);
B = [distance(W(I,:),W(J,:)),...
     distance(W(J,:),W(K,:)),...
     distance(W(K,:),W(I,:))]>eps;
[ID,~] = find(B);
ID = unique(ID);
if(isempty(ID))
    return;
end
[P,T,W] = splitTriangle(P,T,ID,W);
end

function [C] = compute(Wi,P,T,W)
Bp = triangle_barycenter(P,T);
Bw = triangle_barycenter(W,T);
A  = triangle_area(P,T);
C  = num2cell(zeros(row(Wi),3),2);
if(ispoolactive())
    parfor i = 1 : row(Wi)
        C{i} = CoR(Wi(i,:),A,Bp,Bw);
    end
else
    for i = 1 : row(Wi)
        C{i} = CoR(Wi(i,:),A,Bp,Bw);
    end
end
C = cell2mat(C);
end

function [C] = CoR(Wi,A,Bp,Bw)
s = skinning_similarity(Wi,Bw);
C = sum(s.*A.*Bp,1);
S = sum(s.*A,1);
if(S>0)
    C = C/S;
else
    C = zeros(1,3);
end
end