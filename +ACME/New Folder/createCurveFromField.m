function [C] = createCurveFromField(MeshHandle,Field,iso)
if(nargin<3)
    iso = 0.5;
end
C = meandering_triangle(MeshHandle.Face,Field,iso);
% S = subdivide_segment(S);
for i = 1 : row(C)
    if(~isempty(C{i}))
        C{i} = buildCurveEdge(MeshHandle.Vertex,...
                              MeshHandle.Face,...
                              C{i});
        C{i} = splitCData(C{i});
    end
end
end

function [S] = buildCurveEdge(P,T,S)
s    = struct('B',[],'T',[],'E',[]);
s.B  = interleave(S.A,S.B);
s.T  = repelem(S.T,2,1);
s.E  = reshape(1:row(s.B),2,floor(row(s.B)/2))';

[~,j,k] = uniquetol(from_barycentric(P,T,s.T,s.B),0.0001,'ByRows',true);

s.B  =  s.B(j,:);
s.T  =  s.T(j,:);
s.E  =  k(s.E);
if(numel(s.E)==2)
    s.E = make_row(s.E);
end
s.E(s.E(:,1)==s.E(:,2),:) = [];
S = s;
end

function [C] = splitCData(S)
[S.E,E] = findSingleCurve(S.E);
C = repmat(emptyStruct(S),numel(E),1);
for i = 1 : numel(E)
    [C(i).E,I] = reindex(S.E(E{i},:));
    if(numel(C(i).E)==2)
        C(i).E = make_row(C(i).E);
    end
    C(i).B = S.B(I,:);
    C(i).T = S.T(I,:);
end
end

function [E,I] = findSingleCurve(E)
% find possible roots
R = [];
% [~,R] = duplicated(E(:,1));
R = [R;find(~ismember(E(:,1),E(:,2)))];

I = [];
if( isempty(R) )
    [~,R] = duplicated(E(:,1));
    R = setdiff(1:row(E),R);
    R = R(1);
end

e = E(R(1),:);
Q = E(setdiff(1:row(E),R(1)),:);
R(1) = [];
first = 1;
while(~isempty(Q))
    j = find(Q(:,1)==e(end,2));
    if(e(end,2)==e(first,1))
        I = [I;{(first:row(e))'}];
        first = row(e)+1;
    end
    if(isempty(j))
        I = [I;{(first:row(e))'}];
        first = row(e)+1;
        if(isempty(R))
            j = 1;
        else
            j = find((Q(:,1)==E(R(1),1))&(Q(:,2)==E(R(1),2)));
            R(1) = [];
            if(isempty(j))
                j = 1;
            end
        end
    end
    j = j(1);
    e = [e;Q(j,:)];
    Q(j,:)=[];
end
I = [I;{(first:row(e))'}];
I = erase_empty(I);
E = e;
end