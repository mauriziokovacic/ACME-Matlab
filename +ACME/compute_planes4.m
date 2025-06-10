[~,b] = sort(W_,2,'descend');
b = b(:,1:2);
v = skinning_valence(W_);
b(v==1,2)=0;
b = sort(b,2);
e = unique(b,'rows');

t = zeros(size(e,1),3);
for i = 1 : size(e,1)
    vid = find( b(i,1)==e(:,1) | b(i,2)==e(:,2));% | b(i,2)==e(:,3) );
    V = P(vid,:);
    C = mean(V,1);
    V = V - repmat(C,size(V,1),1);
    V = V'*V;
    [u,~,~] = svd(V);
    t(i,:) = u(:,1)';
end

for i = 1 : size(P,1)
    v = b(i,:);
    tid(i) = find(v(1)==e(:,1) & v(2) == e(:,2) );%& v(3) == e(:,3));
%     N_(i,:) = t(tid,:);
end

% N_ = reorient_plane(P_,N_,P);

clear u b e C V vid v t s i;