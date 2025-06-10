function [P_,N_,W_] = find_contact_planes2(P,N,W,C)
linint = @(Vi,Vj,t) (1-t).*Vi+t.*Vj;

P_ = zeros(size(P));
N_ = zeros(size(N));
W_ = W;


ID = cell(size(W,2),1);
V  = (1:size(P,1))';
for w = 1 : size(W,2)
    if( ~isempty(V) )
        I = intersect(V,find(W(:,w)>=0.5));
        V = setdiff(V,I);
        ID{w} = I;
    end
end


for s = 1 : size(ID,1)
    for n = 1 : numel(ID{s})
        i = ID{s}(n);
        Pi = P(i,:);
        Ni = N(i,:);
        Pj = C{s}.P(C{s}.E(:,1),:);
        Pk = C{s}.P(C{s}.E(:,2),:);
        Nj = C{s}.N(C{s}.E(:,1),:);
        Nk = C{s}.N(C{s}.E(:,2),:);
        Wj = C{s}.W(C{s}.E(:,1),:);
        Wk = C{s}.W(C{s}.E(:,2),:);
        [X,t] = project_point_on_segment(Pj,Pk,Pi);
        [~,j] = min(vecnorm3(X-Pi));
        P_(i,:) = X(j,:);
        N_(i,:) = normr(linint(Nj(j,:),Nk(j,:),t(j,:)));
        W_(i,:) = linint(Wj(j,:),Wk(j,:),t(j,:));
    end
end




end
