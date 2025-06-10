function [N_] = VotingSystem(P,T,C,P_)
% Find adjacency between triangles
A     = Adjacency(P,T,'face');
[i,j] = find(A);
A     = cell(row(T),1);
for n = 1 : numel(i)
    A{i(n)} = [A{i(n)};j(n)];
end

% Find triangles
t = cell2mat(cellfun(@(c) c.T, C, 'UniformOutput', false));

% Find all vertices folding in each triangle
X      = cell2mat(cellfun(@(c) c.P,C,'UniformOutput',false));
U      = cell2mat(cellfun(@(c) c.U,C,'UniformOutput',false));
N_     = cell2mat(cellfun(@(c) c.N,C,'UniformOutput',false));
KDTree = KDTreeSearcher(X);
I      = knnsearch(KDTree,P_,'K',1);
U      = U(I,:);
N_     = N_(I,:);
V      = cell(row(T),1);
for i = 1 : row(P)
    tt = [t(I(i));A{t(I(i))}];
    for j = 1 : numel(tt)
        V{tt(j)} = [V{tt(j)};i];
    end
end
V = cellfun(@(v) unique(v), V, 'UniformOutput', false);

% Compute D = P-P_ for all the vertices
D = normr(P-P_);

% For each triangle collect the D
N = cell(row(T),1);
for i = 1 : row(T)
    N{i} = [D(V{i},:);N_(V{i},:)];%specular_direction(U(V{i},:),D(V{i},:));
end

% For each triangle orient all D such that D.D(1)>=0;
for i = 1 : row(T)
    if(isempty(N{i}))
        continue;
    end
    j    = find( dot(N{i},repmat(N{i}(1,:),row(N{i}),1),2) >= 0 );
    k    = setdiff(1:row(N{i}),j);
    N{i} = normr(mean([mean(N{i}(j,:),1);-mean(N{i}(k,:),1)],1));
end

% For each triangle compute mean of D
% N = cellfun(@(n) normr(mean(n,1)),N,'UniformOutput',false);

% For each vertex collect D from triangles
N_ = cell(row(P),1);
for i = 1 : row(T)
    if(isempty(N{i}))
        continue;
    end
    j = V{i};
    for k = 1 : numel(j)
        N_{j(k)} = [N_{j(k)};N{i}];
    end
end

% Orient D acconrdingly
N_ = cellfun(@(n) sign_of(dot(n,repmat(n(1,:),row(n),1),2)) .* n,N_,'UniformOutput',false);

% Compute mean of D
N_ = cellfun(@(n) normr(mean(n,1)),N_,'UniformOutput',false);

% Reorient
N_ = reorient_plane(P_,cell2mat(N_),P);
end