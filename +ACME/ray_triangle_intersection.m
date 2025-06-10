function [X] = ray_triangle_intersection(O,D,Pi,Pj,Pk)
if( row(O) == 1 )
    O = repmat(O,row(Pi),1);
    D = repmat(D,row(Pi),1);
end
if( row(Pi) == 1 )
    Pi = repmat(Pi,row(O),1);
    Pj = repmat(Pj,row(O),1);
    Pk = repmat(Pk,row(O),1);
end
X = NaN(row(O),3);
P = (Pi+Pj+Pk)/3;
N = normr(cross(Pj-Pi,Pk-Pi,2));
d = dot(D,N,2);
i = find(d<0);
if( ~isempty(i) )
    t = point_plane_distance(P(i,:),N(i,:),O(i,:))/d(i);
    Q = O(i,:)+t*D(i,:);
    B = barycentric_coordinates(Pi(i,:),Pj(i,:),Pk(i,:),Q);
    [j,~] = find(B<0);
    j = setdiff(1:row(Q),j);
    X(i(j),:) = Q(j,:);
end
end