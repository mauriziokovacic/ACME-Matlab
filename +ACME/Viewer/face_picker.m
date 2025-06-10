function [I] = face_picker(P,T,verbose)
if( nargin < 3 )
    verbose = false;
end
fig  = CreateViewer3D();
mesh = display_mesh(P,zeros(size(P)),T,[0.5 0.5 0.5],'wired');
mesh.HandleVisibility = 'off';
set(mesh,'ButtonDownFcn',@(object,event) face_picker_handler(object,event,P,T,verbose));
set(fig,'DeleteFcn',@(object,event) face_picker_handler());

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
I = face_picker_handler();
end


function [I] = face_picker_handler(object,event,P,T,verbose)
persistent KDTree;
persistent i;
if(nargin==0)
    I = i;
    clear i KDTree;
    return;
end
if( isempty(KDTree) )
    KDTree = KDTreeSearcher(triangle_barycenter(P,T));
end
x = knnsearch(KDTree,event.IntersectionPoint,'K',1);
if(ismember(x,i))
    i = setdiff(i,x);
else
    i = [i;x];
end
if( ~isempty(i) )
    k = repmat([0.5 0.5 0.5],row(T),1);
    k(i,:) = repmat([1 0 0],numel(i),1);
    hold on;    
    object.FaceVertexCData = k;
    object.FaceColor       = 'flat';
    hold off;
    if( verbose )
        disp(['Face#  : ', num2str(i(end))]);
        disp(['Vert.ID: ', num2str(T(i(end),:))]);
        disp(['Clicked: ', num2str(x)]);
    end
end
end