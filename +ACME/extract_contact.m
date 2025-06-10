function [P_,N_,W_] = extract_contact(P,N,W,C)
linint = @(Vi,Vj,t) (1-t).*Vi+t.*Vj;
P_ = cell(size(P,1),1);
N_ = cell(size(P,1),1);
W_ = cell(size(P,1),1);

% weight = zeros(size(P,1),1);
% curve  = zeros(size(P,1),1);
% index  = zeros(size(P,1),1);
% alpha  = zeros(size(P,1),1);
% value  = Inf(size(P,1),1);
% 
% for w = 1 : size(W,2)
%     if( ~isempty(C{w}) )
%         S = C{w}.S;
%         E = C{w}.E;
%         i = find(W(:,w)>=0.5);
% 
%         for s = 1 : size(S,1)
%             j  = cell2mat(S(s));
%             Pi = P(i,:);
%             Pj = C{w}.P(j,:);
%             
%             [c,~,~,u] = PCA(Pj);
%             
%             Pi = project_point_on_plane(c,u,Pi);
%             Pj = project_point_on_plane(c,u,C{w}.P);
%             
%             for k = 1 : size(Pi,1)
%                 [X,t] = project_point_on_segment(Pj(E(j,1),:),Pj(E(j,2),:),Pi(k,:));
%                 [d,n] = min(vecnorm3(Pi(k,:)-X));
%                 if( d < value(i(k)) )
%                     weight(i(k)) = w;
%                     curve(i(k))  = s;
%                     index(i(k))  = n;
%                     alpha(i(k))  = t(n);
%                     value(i(k))  = d;
%                 end
%             end
%             
%         end
%     end
% end
% 
% for i = 1 : size(P,1)
%     if( weight(i) == 0 )
%         continue;
%     end
%     w = weight(i);
%     c = curve(i);
%     j = cell2mat(C{w}.S(c));
%     j = j(index(i));
%     t = alpha(i);
%     
%     P_(i,:) = linint(C{w}.P(C{w}.E(j,1),:),...
%                      C{w}.P(C{w}.E(j,2),:),...
%                      t);
%                  
%     N_(i,:) = linint(C{w}.N(C{w}.E(j,1),:),...
%                      C{w}.N(C{w}.E(j,2),:),...
%                      t);
% 
%     W_(i,:) = linint(C{w}.W(C{w}.E(j,1),:),...
%                      C{w}.W(C{w}.E(j,2),:),...
%                      t);
% end



Pj = [];
Pk = [];
Nj = [];
Nk = [];
Cj = [];
Ck = [];
Wj = [];
Wk = [];
ID = [];

for w = 1 : size(W,2)
    if( ~isempty(C{w}) )
        E  = C{w}.E;
        Pj = [Pj;C{w}.P(E(:,1),:)];
        Pk = [Pk;C{w}.P(E(:,2),:)];
        Nj = [Nj;C{w}.N(E(:,1),:)];
        Nk = [Nk;C{w}.N(E(:,2),:)];
        Cj = [Cj;C{w}.C(E(:,1),:)];
        Ck = [Ck;C{w}.C(E(:,2),:)];
        Wj = [Wj;C{w}.W(E(:,1),:)];
        Wk = [Wk;C{w}.W(E(:,2),:)];
        ID = [ID;repmat(w,size(C{w}.P,1),1)];
    end
end

parfor i = 1 : size(P,1)
    Pi = P(i,:);
    Ni = N(i,:);
    Wi = W(i,:);
    [~,w] = find(Wi);
    v = find(ismember(ID,w));
    
    [X,t] = project_point_on_segment(Pj(v,:),Pk(v,:),Pi);
    U = normr(linint(Pj(v,:)-Cj(v,:),Pk(v,:)-Ck(v,:),t));
    S = linint(Wj(v,:),Wk(v,:),t);
    
    dX = 1./vecnorm3(Pi-X);
    dU = dot(U,repmat(Ni,size(U,1),1),2);
    dS = 1./vecnorm(Wi-S,2,2);
    
    F = dX .* dU .* dS;
    
    [~,j] = max(F);
    j = j(1);
    
    P_{i} = X(j,:);
    N_{i} = linint(Nj(v(j),:),Nk(v(j),:),t(j));
    W_{i} = S(j,:);
    
end

P_ = cell2mat(P_);
N_ = reorient_plane(P_, cell2mat(N_), P);
W_ = cell2mat(W_);

% for w = 1 : size(W,2)
%     if( ~isempty(C{w}) )
%         Pj = C{w}.P;
%         E  = C{w}.E;
%         Nj = normr(C{w}.P-C{w}.C);
%         Wj = C{w}.W;
%         k = find(W(:,w)>=0.5);
%         for i = 1 : numel(k)
%             Pi = P(k(i),:);
%             Ni = repmat(N(k(i),:),size(Nj,1),1);
%             Wi = W(k(i),:);
%             [X,t] = project_point_on_segment(Pj(E(:,1),:),Pj(E(:,2),:),Pi);
%             D = 1./vecnorm3(Pi-X);
%             U = linint(Nj(E(:,1),:),Nj(E(:,2),:),t);
%             S = linint(Wj(E(:,1),:),Wj(E(:,2),:),t);
%             
%             F = D .* dot(Ni,U,2);
%             [~,j] = max(F);
%             j = j(1);
%             
%             P_(k(i),:) = X(j,:);
%             N_(k(i),:) = linint(C{w}.N(E(j,1),:),C{w}.N(E(j,2),:),t(j));
%             W_(k(i),:) = S(j,:);
%         end
%     end
% end



end