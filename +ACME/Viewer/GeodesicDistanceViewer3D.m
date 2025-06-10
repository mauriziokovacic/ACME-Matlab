function [U] = GeodesicDistanceViewer3D(P,N,T)
[A,t,L,~] = heat_diffusion_data(P,T,[]);
Ill       = 0.0001*speye(row(P));
AtL       = decomposition(A+t*L+Ill);
L         = decomposition(L+Ill);
clear Ill A t;

fig  = CreateViewer3D('Name','Geodesic Distance Viewer','right');
mesh = display_mesh(P,N,T,[0.5 0.5 0.5]);
cmap('parula',[],true);
mesh.HandleVisibility = 'off';
set(fig,'DeleteFcn',@(object,event) geodesic_field());
set(mesh,'ButtonDownFcn',@(object,event) geodesic_field(object,event,P,T,AtL,L));
run = true;
while( run )
    if( ~isvalid(fig) )
        break;
    end
    char = get(fig, 'CurrentCharacter');
    if( char == 13 )
        run = false;
    end
    drawnow;
end
U = mesh.FaceVertexCData;
end

function geodesic_field(object,event,P,T,AtL,L)
persistent KDTree;
persistent i;
persistent Pi;
if(nargin==0)
    clear i Pi;
    return;
end
if( isempty(KDTree) )
    KDTree = KDTreeSearcher(P);
end
delete(Pi);
x = knnsearch(KDTree,event.IntersectionPoint,'K',1);
if(ismember(x,i))
    i = setdiff(i,x);
else
    i = [i;x];
end
if( isempty(i) )
    object.FaceColor       = [0.5 0.5 0.5];
    object.FaceVertexCData = [];
else
    hold on;
    Pi = point3(P(i,:),20,'r','filled');
    
    k = zeros(row(P),1);
    k(i) = 1;
    
    u  = AtL\k;
    gu = normr(compute_gradient(P,T,u));
    du = compute_divergence(P,T,gu);
    u  = L\du;
    
    object.FaceColor       = 'interp';
    object.FaceVertexCData = u;
end
end