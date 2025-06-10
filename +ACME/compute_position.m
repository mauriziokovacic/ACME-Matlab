function [Q] = compute_position(P,T,AA)
Q = zeros(size(P));
I = T(:,1);
J = T(:,2);
K = T(:,3);
E = [ P(J,:)-P(I,:); ...
	  P(K,:)-P(J,:); ...
	  P(I,:)-P(K,:) ];
I = [I,J;J,K;K,I];
C = Adjacency(P,T,'cot');
for n = 1 : size(I,1)
    i = I(n,1);
    j = I(n,2);
    Ri = vrrotvec2mat(AA(i,:));
    Rj = vrrotvec2mat(AA(j,:));
    R = Ri+Rj;
    w = C(i,j);
    Q(i,:) = Q(i,:) + w * ( -E(n,:) * R );
end
Q = P+Q;
end