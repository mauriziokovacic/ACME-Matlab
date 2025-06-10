function [U] = HarmonicFieldViewer3D(P,N,T)
U = [];
L = cotangent_Laplacian(P,T);
fig  = CreateViewer3D('Name','Harmonic Field Viewer','right');
mesh = display_mesh(P,N,T,[0.5 0.5 0.5]);
cmap('parula',[],true);
mesh.HandleVisibility = 'off';
set(mesh,'ButtonDownFcn',@(object,event) harmonic_field(object,event,P,L));
run = true;
while( run )
    if( ~isvalid(fig) )
        return;
    end
    char = get(fig, 'CurrentCharacter');
    if( char == 13 )
        run = false;
    end
    drawnow;
end
U = harmonic_field();
end

function [U] = harmonic_field(object,event,P,L)
persistent KDTree;
persistent i j;
persistent Pi Pj;
if(nargin==0)
    U = object.FaceVertexCData;
    clear i j Pi Pj;
    return;
end
if( isempty(KDTree) )
    KDTree = KDTreeSearcher(P);
end
x = knnsearch(KDTree,event.IntersectionPoint,'K',1);
if strcmpi(get(get_patch(object),'SelectionType'),'alt')
    if(ismember(x,j))
        j = setdiff(j,x);
    else
        j = [j;x];
    end
else
    if(ismember(x,i))
        i = setdiff(i,x);
    else
        i = [i;x];
    end
end
delete(Pi);
delete(Pj);
if( isempty([i;j]) )
    object.FaceColor       = [0.5 0.5 0.5];
    object.FaceVertexCData = [];
else
    hold on;
    Pi = point3(P(i,:),20,'r','filled');
    hold on;
    Pj = point3(P(j,:),20,'b','filled');
    
    M = add_constraints(L,[i;j],[]);
    k = zeros(row(P),1);
    k(i) = 1;
    U = M\k;
    object.FaceColor       = 'interp';
    object.FaceVertexCData = U;
end
end