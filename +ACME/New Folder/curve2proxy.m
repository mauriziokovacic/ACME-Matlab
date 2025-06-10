function [G] = curve2proxy(C,n,varargin)
O = cell2mat(arrayfun(@(c) mean(c.getPoint(),1), C, 'UniformOutput',false));
U = normr(cell2mat(arrayfun(@(c) mean(c.getBitangent(),1), C, 'UniformOutput',false)));
i = ceil(numel(C)/2);
v = C(i).fetchPoint(0)/O(i,:);
V = normr(project_normal_on_plane(O,U,v));

Q = arrayfun(@(c) c.fetchPoint(linspace(0,1,n)), C, 'UniformOutput', false);
Q = arrayfun(@(i) Q{i}-O(i,:), (1:numel(C))', 'UniformOutput', false);
Q = arrayfun(@(i) normr(project_point_on_plane([0 0 0],U(i,:),Q{i})),...
             (1:numel(C))','UniformOutput',false);
x = cell(numel(C),1);
for i = 1 : numel(C)
    for t = linspace(0,2*pi,n)
        R = axang2rotm([U(i,:) t]);
        x{i} = [x{i};(R * V(i,:)')'];
    end
end
T = cell(numel(C),1);
for i = 1 : numel(C)
    T{i} = zeros(row(x{i}),1);
    A = Q{i}(1:end-1,:);
    B = Q{i}(2:end,:);
    t = linspace(0,1,n)';
    t = [t(1:end-1) t(2:end)];
    for j = 1 : row(x{i})
        p = x{i}(j,:);
        [q,a] = project_point_on_segment(A, B,p);
        k     = min_index(distance(q, p, 2));
        T{i}(j) = (1-a(k)) * t(k,1) + a(k) * t(k,2);
    end
end

[P,N,W] = C.fetchData({'Point','Normal','Weight'},T,varargin{:});
P = permute(reshape(cell2mat(P),n,numel(C),[]),[2,1,3]);
N = permute(reshape(cell2mat(N),n,numel(C),[]),[2,1,3]);
W = permute(reshape(cell2mat(W),n,numel(C),[]),[2,1,3]);
V = repmat(gaussmf(linspace(-5,5,32),[3 0])',1,n);
G = ContactProxy('Point',  P,...
                 'Normal', N,...
                 'Weight', W,...
                 'Value',  V);
G.update();
end