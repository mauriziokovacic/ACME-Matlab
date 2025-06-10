function [U] = HeatDiffusionViewer3D(P,N,T,i)
if( nargin < 4 )
    i = [];
end
fig  = CreateViewer3D('Name','Heat Diffusion Viewer','right');
mesh = display_mesh(P,N,T,[0.5 0.5 0.5]);
cmap('king',256);
mesh.HandleVisibility = 'off';

slider = uicontrol( fig,...
    'Style', 'slider',...
    'Position', [100, 10, 200, 20],...
    'Min', 0,...
    'Max', mesh_scale(P),...
    'SliderStep', [0.001 0.1],...
    'Value', 0.1);
addlistener( slider, 'ContinuousValueChange',...
             @(object,event) heat_diffusion_field(mesh,[],P,T,i,slider.Value) );
set(fig,'DeleteFcn',@(object,event) heat_diffusion_field());
set(mesh,'ButtonDownFcn',@(object,event) heat_diffusion_field(object,event,P,T,i,slider.Value));
keep = true;
while( keep )
    if( ~isvalid(fig) )
        break;
    end
    char = get(fig, 'CurrentCharacter');
    if( char == 13 )
        keep = false;
    end
    drawnow;
end
if( isvalid(mesh) )
    set(mesh,'ButtonDownFcn',[]);
    U = mesh.FaceVertexCData;
end
if( isvalid(fig) )
    close(fig);
end
end

function heat_diffusion_field(object,event,P,T,ID,diffusion_time)
persistent KDTree;
persistent i;
persistent Pi;
persistent A L t AtL;
if(nargin==0)
    clear i Pi A L t AtL KDTree;
    return;
end
if( isempty(KDTree) )
    KDTree = KDTreeSearcher(P);
end
if( isempty(A) )
    A = barycentric_area(P,T);
end
if( isempty(L) )
    L = cotangent_Laplacian(P,T);
end
if( isempty(t) )
    t = 0;
end
if( t ~= diffusion_time )
    t   = diffusion_time;
    AtL = decomposition(A+t*L + 0.0001*speye(row(P)));
end
if( isempty(i) && ~isempty(ID) )
    i = ID;
end
delete(Pi);

if( ~isempty(event) )
    x = knnsearch(KDTree,event.IntersectionPoint,'K',1);
    if(ismember(x,i))
        i = setdiff(i,x);
    else
        i = [i;x];
    end
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
    
    object.FaceColor       = 'interp';
    object.FaceVertexCData = u;
end
end