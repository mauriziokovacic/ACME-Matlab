function [P_,N_,W_] = find_contact2(P,CoR,R,C)
P_ = cell(row(P),1);
N_ = cell(row(P),1);
W_ = cell(row(P),1);
R  = cellfun(@(i) fi(R.I(i,:)),num2cell(1:row(P)),'UniformOutput',false);
    function [r] = fi(r)
        r = find(r);
        if(any(r>row(C)))
            r = (1:row(C))';
        end
    end

parfor i = 1 : row(P)
    D  = normr(P(i,:)-CoR(i,:));
    r  = R{i};
    e = -Inf;
    for j = 1 : numel(r)
        E = dot(repmat(D,row(C{r(j)}.U),1),C{r(j)}.U,2) .* 1./sum((C{r(j)}.P-P(i,:)).^2,2);
        [E,k] = max(E);
%         P_{i} = [P_{i};C{r(j)}.P(k,:)];
% %         N_{i} = [N_{i};C{r(j)}.N(k,:);CoR(i,:)-C{r(j)}.CoR(k,:)];
%         N_{i} = [N_{i};CoR(i,:)-C{r(j)}.CoR(k,:)];
%         W_{i} = [W_{i};C{r(j)}.W(k,:)];
        if(E>e)
            e = E;
            P_{i} = C{r(j)}.P(k,:);
            N_{i} = CoR(i,:)-C{r(j)}.CoR(k,:);
            W_{i} = C{r(j)}.W(k,:);
        end
    end
%     P_{i} = mean(P_{i},1);
%     N_{i} = normr(mean(N_{i},1));
%     W_{i} = mean(W_{i},1);
end
P_ = cell2mat(P_);
N_ = cell2mat(N_);
W_ = cell2mat(W_);
N_ = reorient_plane(P_,N_,P);
end