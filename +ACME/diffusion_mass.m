function [M] = diffusion_mass( P, T, W )
p = size(P,1);
w = size(W,2);

[I,J,K] = tri2ind(T);

Pi = P(I,:);
Pj = P(J,:);
Pk = P(K,:);

E = [I J; J K; K I];

Lij = vecnorm3(Pj-Pi);
Ljk = vecnorm3(Pk-Pj);
Lki = vecnorm3(Pi-Pk);

[~ , ID] = sort(W,2,'descend');
ID = ID(:,1);

l = accumarray([I;J;J;K;K;I],[Lij;Lij;Ljk;Ljk;Lki;Lki],[p,1]);
ne = accumarray([I;J;J;K;K;I],1,[p,1]);
l = l ./ ne;

t = accumarray(ID,l,[w,1]);
n = accumarray(ID,1,[w,1]);

t = t ./ n;
t = (W*t).^2;

M = sparse((1:p)',(1:p)',t,p,p);

end