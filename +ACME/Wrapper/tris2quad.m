function [T,P] = tris2quad(T,P)
[I,J,K] = tri2ind(T);
Pi      = P(I,:);
Pj      = P(J,:);
Pk      = P(K,:);
Pij     = 0.5*(Pi+Pj);
Pjk     = 0.5*(Pj+Pk);
Pki     = 0.5*(Pk+Pi);
C       = (Pi+Pj+Pk)/3;
P       = interleave(Pi,Pij,C,Pki,...
                 Pj,Pjk,C,Pij,...
                 Pk,Pki,C,Pjk);
T       = reshape((1:row(P))',4,row(P)/4)';
[P,T]   = soup2mesh(P,T);
end