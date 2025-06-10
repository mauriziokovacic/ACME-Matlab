function [I] = ShortestPathViewer3D(P,N,T,verbose)
G    = graph(clamp(Adjacency(P,T,'comb'),0,1));
fig  = CreateViewer3D('Name','Shortest Path Viewer','right');
mesh = display_mesh(P,N,T,[0.5 0.5 0.5]);
mesh.HandleVisibility = 'off';
set(mesh,'ButtonDownFcn',@(object,event) EventHandler(object,event,P,G,verbose));
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
I = EventHandler();
end


function [I] = EventHandler(object,event,P,G,verbose)
persistent KDTree;
persistent Path;
persistent i j;
persistent PHandle IPoint JPoint;
if( nargin == 0 )
    I = Path;
    clear KDTree Path i j PHandle IPoint JPoint;
    return;
end
if( isempty(KDTree) )
    KDTree = KDTreeSearcher(P);
end
x = event.IntersectionPoint;
v = knnsearch(KDTree, x, 'K', 1);
if( isRightClick() )
    if( i == v )
        j = [];
    else
        j = v;
    end
else
    if( j == v )
        i = [];
    else
        i = v;
    end
end
delete(PHandle);
delete(IPoint);
delete(JPoint);
txt = 'Source: ';
if( ~isempty(i) )
    hold on;
    IPoint = point3(P(i,:),20,'r','filled');
    txt = strcat(txt,num2str(i));
else
    txt = strcat(txt,'[]');
end
txt = strcat(txt,' Target: ');
if( ~isempty(j) )
    hold on;
    JPoint = point3(P(j,:),20,'g','filled');
    txt = strcat(txt,num2str(j));
else
    txt = strcat(txt,'[]');
end

if( ~isempty(i) && ~isempty(j) )
    Path = shortestpath(G,i,j);
    hold on;
    PHandle = line3([P(Path(1:end-1),:) P(Path(2:end),:)],'Color','b');
    txt = strcat(txt,' Path: ',num2str(Path));
end
hold off;
if(verbose)
    disp(txt);
end
end