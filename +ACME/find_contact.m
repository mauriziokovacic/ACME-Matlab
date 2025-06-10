function [P_,N_,W_] = find_contact(P,N,T,R,C)
P_ = cell(row(P),1);
N_ = cell(row(P),1);
W_ = cell(row(P),1);

i = [];
for c = 1 : row(C)
    i = [i;unique(T(C{c}.T,:))];
end
i = unique(i);
L = cotangent_Laplacian(P,T);
% L = add_constraints(L,i,[]);
% L = decomposition(L);

for c = 1 : row(C)
    i = find(R.I(:,c));
    if( row(C{c}.S) == 1 )
        [p,n,w] = disk_region(P(i,:),C{c});
        for j = 1 : numel(i)
            P_{i(j)} = [P_{i(j)};p(j,:)];
            N_{i(j)} = [N_{i(j)};n(j,:)];
            W_{i(j)} = [W_{i(j)};w(j,:)];
        end
    else
        [p,n,w] = bounded_region(P,N,T,C{c},L,i);
        for j = 1 : numel(i)
            P_{i(j)} = [P_{i(j)};p(j,:)];
            N_{i(j)} = [N_{i(j)};n(j,:)];
            W_{i(j)} = [W_{i(j)};w(j,:)];
        end
    end
end

% Outside region
[i,~] = find(R.I(:,row(C)+1:end));
i = unique(i);
[p,n,w] = outside_points(P(i,:),C);
for j = 1 : numel(i)
    P_{i(j)} = [P_{i(j)};p(j,:)];
    N_{i(j)} = [N_{i(j)};n(j,:)];
    W_{i(j)} = [W_{i(j)};w(j,:)];
end

P_ = cell2mat(cellfun(@(Data) mean(Data,1),P_,'UniformOutput',false));
N_ = cell2mat(cellfun(@(Data) mean(Data,1),N_,'UniformOutput',false));
W_ = cell2mat(cellfun(@(Data) mean(Data,1),W_,'UniformOutput',false));
N_ = reorient_plane(P_,N_,P);
end

function [P_,N_,W_] = bounded_region(P,N,T,C,L,I)
s = mesh_scale(P(I,:));
P_ = cell(numel(I),1);
N_ = cell(numel(I),1);
W_ = cell(numel(I),1);

i = unique(T(C.T,:));
L = add_constraints(L,i,[]);
L = decomposition(L+speye(row(P))*0.0001);

F = zeros(numel(I),row(C.S));
for s = 1 : row(C.S)
    t      = C.T(C.E(C.S{s},:));
    i      = unique(T(t,:));
    U      = zeros(row(P),1);
    U(i)   = 1;
    U      = L\U;%linear_problem(L,U);
    F(:,s) = U(I);
end
[F,S] = sort(F,2,'descend');
F = F(:,1);
S = S(:,1);

for v = 1 : numel(I)
    i = I(v);
    j = unique(C.E(C.S{S(v)},:));
    D = C.D(j,:);
    U = C.U(j,:);
    d = dot(repmat(N(i,:),numel(j),1),U,2);
    d = 1./vecnorm3(P(i,:)-C.P(j,:));
    [~,k] = max(d);
    j = j(k);
    P_{v} = C.P(j,:);
    N_{v} = C.N(j,:);
    W_{v} = C.W(j,:);
end
P_ = cell2mat(P_);
N_ = cell2mat(N_);
W_ = cell2mat(W_);
end

function [P_,N_,W_] = disk_region(P,C)
KDTree  = KDTreeSearcher(C.P);
I       = knnsearch(KDTree,P,'K',1);
P_ = C.P(I,:);
N_ = C.N(I,:);
W_ = C.W(I,:);
end

function [P_,N_,W_] = outside_points(P,C)
P_      = cell2mat(cellfun(@(c) c.P,C,'UniformOutput',false));
N_      = cell2mat(cellfun(@(c) c.N,C,'UniformOutput',false));
W_      = cell2mat(cellfun(@(c) c.W,C,'UniformOutput',false));
KDTree  = KDTreeSearcher(P_);
I       = knnsearch(KDTree,P,'K',1);
P_ = P_(I,:);
N_ = N_(I,:);
W_ = W_(I,:);
end