function [K] = gaussian_curvature(P,T)
    A = diag(barycentric_area(P,T));
    [I,J,K] = tri2ind(T);
    Pi = P(I,:);
    Pj = P(J,:);
    Pk = P(K,:);
    Eij = normr(Pj - Pi);
    Ejk = normr(Pk - Pj);
    Eki = normr(Pi - Pk);
    theta = accumarray([I;J;K],[angle(Eij,-Eki);angle(Ejk,-Eij);angle(Eki,-Ejk);]);
    K = ( 2*pi - theta ) ./ A;
end