function [P,T,M] = subdivide(P,T,iteration)
if(nargin<3)
    iteration = 1;
end
if(isedge(T))
    fun = @(t,i) xedge(t,i);
else
    if(istri(T))
        fun = @(t,i) xtri(t,i);
    else
        if(isquad(T))
            fun = @(t,i) xquad(t,i);
        else
            error('Topology not supported yet');
        end
    end
end
[M,T]   = fun(T,iteration);
P       = M*P;
[P,T,I] = soup2mesh(P,T);
M       = M(I,:);
end

% function [P,T] = subdivideTriangle(P,T)
% [I,J,K] = tri2ind(T);
% Pi  = P(I,:);
% Pj  = P(J,:);
% Pk  = P(K,:);
% Pij = 0.5*(Pi+Pj);
% Pjk = 0.5*(Pj+Pk);
% Pki = 0.5*(Pk+Pi);
% P   = interleave(Pi ,Pij,Pki,...
%                  Pj ,Pjk,Pij,...
%                  Pk ,Pki,Pjk,...
%                  Pij,Pjk,Pki);
% T   = reshape(1:row(P),3,row(T)*4)';
% end
% 
% function [P,T] = subdivideQuad(P,T)
% [I,J,K,L] = quad2ind(T);
% Pi  = P(I,:);
% Pj  = P(J,:);
% Pk  = P(K,:);
% Pl  = P(L,:);
% Pij = 0.5 *(Pi+Pj);
% Pjk = 0.5 *(Pj+Pk);
% Pkl = 0.5 *(Pk+Pl);
% Pli = 0.5 *(Pl+Pi);
% C   = 0.25*(Pi+Pj+Pk+Pl);
% P   = interleave(Pi ,Pij,C  ,Pli,...
%                  Pj ,Pjk,C  ,Pij,...
%                  Pk ,Pkl,C  ,Pjk,...
%                  Pl ,Pli,C  ,Pkl);
% T   = reshape(1:row(P),4,row(T)*4)';
% end