function [N] = vertex_normal(P,F,type)
if( nargin < 3 )
    type = 'avg';
end
if(isempty(F))
    N = [];
    return;
end
type = lower(type);
if(istri(F))
    N = triangle_normal(P,F);
    switch type
        case 'avg'
            W = ones(row(F),1);
        case 'area'
            W = triangle_area(P,F);
        case 'angle'
            [I,J,K] = tri2ind(F);
            Eij = normr(P(J,:)-P(I,:));
            Ejk = normr(P(K,:)-P(J,:));
            Eki = normr(P(I,:)-P(K,:));
            W = [vecangle(Eij,-Eki) vecangle(Ejk,-Eij) vecangle(Eki,-Ejk)];
    %         W = polyvert_fun(T,P,@(a,b,c) angle(normr(b-a),normr(c-a)));
    end
    N = normr(face2vertex(N,F,W));
else
    F = poly2wedge(F);
    N = triangle_normal(P,F);
    switch type
        case 'avg'
            W = ones(row(F),1);
        case 'area'
            W = triangle_area(P,F);
        case 'angle'
            [I,J,K] = tri2ind(F);
            Eij = normr(P(I,:)-P(J,:));
            Ejk = normr(P(K,:)-P(J,:));
            W = vecangle(Eij,Ejk);
    end
    N = normr(accumarrayN(F(:,2),W.*N,[row(P) 3]));
end

end