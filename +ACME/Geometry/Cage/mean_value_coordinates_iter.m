function [MVC] = mean_value_coordinates(P,T,X,eps)
if( nargin < 4 )
    eps = 0.0001;
end

f = @(i,n) sparse(1:numel(i),i,1,numel(i),n);
n = size(P,1);

MVC = cell(size(X,1),1);
parfor v = 1 : size(X,1)
    x = X(v,:);
    U = P-x;
    D = vecnorm3(U);
    j = find(D<eps);
    if( ~isempty(j) )
        j = j(1);
        MVC{v} = f(j,n);
        continue;
    end
    U = U./D;
    
    F = sparse(1,n);
    W = 0;
    for t = 1 : size(T,1)
        [I,J,K] = tri2ind(T(t,:));
        L     = [vecnorm3(U(J,:)-U(K,:)) , ...
                 vecnorm3(U(K,:)-U(I,:)) , ...
                 vecnorm3(U(I,:)-U(J,:))];
        theta = 2*[asin(L(:,1)./2) , asin(L(:,2)./2) , asin(L(:,3)./2)];
        H     = sum(theta,2)/2;
        if( (pi-H) < eps )
            w = [sin(theta(:,1)).*D(J).*D(K) , ...
                 sin(theta(:,2)).*D(K).*D(I) , ...
                 sin(theta(:,3)).*D(I).*D(J)];
            F = (w(1) .* f(I,n) + w(2) .* f(J,n) + w(3) .* f(K,n));
            W = sum(w);
            break;
        end
        C = [(2.*sin(H).*sin(H-theta(:,1))) ./ (sin(theta(:,2)).*sin(theta(:,3))) - 1, ...
             (2.*sin(H).*sin(H-theta(:,2))) ./ (sin(theta(:,3)).*sin(theta(:,1))) - 1, ...
             (2.*sin(H).*sin(H-theta(:,3))) ./ (sin(theta(:,1)).*sin(theta(:,2))) - 1 ];
        S = sign(det([U(I,:);U(J,:);U(K,:)])).*((1-C.^2).^0.5);

        if( (abs(S(:,1))<=eps) || (abs(S(:,2))<=eps) || (abs(S(:,3))<=eps))
            continue;
        end

        w = [(theta(:,1)-C(:,2).*theta(:,3)-C(:,3).*theta(:,2))./(D(I).*sin(theta(:,2)).*S(:,3)) ,...
             (theta(:,2)-C(:,3).*theta(:,1)-C(:,1).*theta(:,3))./(D(J).*sin(theta(:,3)).*S(:,1)),...
             (theta(:,3)-C(:,1).*theta(:,2)-C(:,2).*theta(:,1))./(D(K).*sin(theta(:,1)).*S(:,2))];

         F = F + ((w(1) .* f(I,n) + ...
                   w(2) .* f(J,n) + ...
                   w(3) .* f(K,n)));
         W = W + sum(w);
    end
    MVC{v} = F./W;
               
end

MVC = vertcat(MVC{:});
end