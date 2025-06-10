function [P_,N_,W_] = fit2fold(P,N,T,W,R,C)
linint = @(a,b,t) (1-t).*a+t.*b;
D  = Inf(row(P),1);
P_ = zeros(size(P));
N_ = zeros(size(P));
W_ = sparse(row(W),col(W));
for i = 1 : row(P)
    Pi = P(i,:);
    
    [~,r] = find(R.I(i,:));
    w     = R.W(r);
    if(w(1)==0)
        for c = 1 : row(C)
            [X,t] = project_point_on_segment(C{c}.P(C{c}.E(:,1),:),C{c}.P(C{c}.E(:,2),:),Pi);
            [d,j] = min(vecnorm3(X-Pi));
            d = d(1);
            j = j(1);
            if(D(i)>d)
                D(i)    = d;
                P_(i,:) = X(j,:);
                N_(i,:) = linint(C{c}.N(C{c}.E(j,1),:),C{c}.N(C{c}.E(j,2),:),t(j));
                W_(i,:) = linint(C{c}.W(C{c}.E(j,1),:),C{c}.W(C{c}.E(j,2),:),t(j));
            end
        end
    else
        for n = 1 : numel(r)
            c = r(n);
            [X,t] = project_point_on_segment(C{c}.P(C{c}.E(:,1),:),C{c}.P(C{c}.E(:,2),:),Pi);
            [d,j] = min(vecnorm3(X-Pi));
            d = d(1);
            j = j(1);
            if(D(i)>d)
                D(i)    = d;
                P_(i,:) = X(j,:);
                N_(i,:) = linint(C{c}.N(C{c}.E(j,1),:),C{c}.N(C{c}.E(j,2),:),t(j));
                W_(i,:) = linint(C{c}.W(C{c}.E(j,1),:),C{c}.W(C{c}.E(j,2),:),t(j));
            end
        end
    end
end

end