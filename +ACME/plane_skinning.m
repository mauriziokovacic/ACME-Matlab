function [P,N] = plane_skinning(P0,N0,Pt,Nt,P0_,N0_,Pt_,Nt_,Ip,Wp,Op)
d0 = zeros(row(P0),col(Ip));
dt = zeros(row(P0),col(Ip));
a0 = zeros(row(P0),col(Ip));
at = zeros(row(P0),col(Ip));
D  = zeros(row(P0),3);
Q  = zeros(row(P0),3);
for p = 1 : col(Ip)
    i = Ip(:,p);
    d0(:,p) = point_plane_distance(P0_(i,:),N0_(i,:),P0);
    s       = sign_of(d0(:,p));
    
    dt(:,p) = point_plane_distance(Pt_(i,:),Nt_(i,:),Pt);
    a0(:,p) = dotN(N0,N0_(i,:));
    at(:,p) = dotN(Nt,Nt_(i,:));
    
    fD    = CPSDeformer.function_distance( s.*d0(:,p), s.*dt(:,p) );
    fA    = CPSDeformer.function_angle( a0(:,p), at(:,p) );
    alpha = Op.fetch(fD,Wp(:,p));
    
    n = abs(s.*(dt(:,p)-d0(:,p))) .* ( (1-fA) .* Nt + fA .* -Nt_(i,:));
    
%     p  = Pt + n;
%     
%     dt = point_plane_distance( Pt_, Nt_, Pt );
%     i  = find( ( dt < 0 ) & ( d0 > 0.001 ) );
%     p(i,:) = p(i,:) - dt(i,:) .* Nt_(i,:);
%     
%     d = p-Pt;
    d = n;
    q = fA .* alpha .* ( n + -Nt_(i,:));
    
    D = D + Wp(:,p) .* d;
    Q = Q + Wp(:,p) .* q;
end



P = Pt + 0.2*D;
N = normr(Nt + Q);
end