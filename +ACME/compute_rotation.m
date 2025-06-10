function [ R ] = compute_rotation(P,N,T,G)
angle = @(a,b) acos( dot( a, b, 2 ) );


u = @(i,n) i*ones(n,1);

t = size(T,1);

[U,V,W] = compute_frame(P,N,T,G);
U = normr(cross(V,W,2));

alpha = zeros(size(P,1),6);
axis  = W;

I = T(:,1);
J = T(:,2);
K = T(:,3);

Ei = P(J,:)-P(I,:);
Ej = P(K,:)-P(J,:);
Ek = P(I,:)-P(K,:);

Du = [ dot(Ei,U(I,:),2); dot(Ej,U(J,:),2); dot(Ek,U(K,:),2) ];
Dv = [ dot(Ei,V(I,:),2); dot(Ej,V(J,:),2); dot(Ek,V(K,:),2) ];

D = [Du;Dv];
D(D<-1)=-1;
D(D>1)=1;

a = acos(D);

alpha(I,1) = a(I);
alpha(J,2) = a(J);
alpha(K,3) = a(K);
alpha(I,4) = a(I);
alpha(J,5) = a(J);
alpha(K,6) = a(K);
alpha = mean(alpha,2);

R = [axis,alpha];

end