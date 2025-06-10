function [I] = vertex_picker(P,T,verbose)
if( nargin < 3 || isempty(verbose))
    verbose = false;
end
fig  = CreateViewer3D();
mesh = display_mesh(P,zeros(size(P)),T,[0.5 0.5 0.5],'wired');
mesh.HandleVisibility = 'off';
set(fig,'DeleteFcn',@(object,event) vertex_picker_handler());
set(mesh,'ButtonDownFcn',@(object,event) vertex_picker_handler(object,event,P,verbose));

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
I = vertex_picker_handler();
end


function [I] = vertex_picker_handler(object,event,P,verbose)
persistent KDTree;
persistent i;
persistent ball;
if(nargin==0)
    I = i;
    clear i ball KDTree;
    return;
end
if( isempty(KDTree) )
    KDTree = KDTreeSearcher(P);
end
delete(ball);
x = knnsearch(KDTree,event.IntersectionPoint,'K',1);
if(ismember(x,i))
    i = setdiff(i,x,'stable');
else
    i = [i;x];
end
if( ~isempty(i) )
    hold on;
    ball = point3(P(i,:),20,'r','filled');
    hold off;
    if( verbose )
        disp(['Vertex#: ', num2str(i(end))]);
        disp(['Pos.   : ', num2str(P(i(end),:))]);
        disp(['Clicked: ', num2str(x)]);
    end
end
end