function [N_] = ContactPlaneOrientationViewer(P,N,T,P_,N_)
warning('off');
fig  = figure;
ax   = CreateAxes3D(fig);
mesh = display_mesh(P,N,T,normal2color(N_),'face');
mesh.HandleVisibility = 'off';

set(mesh,'ButtonDownFcn',@(object,event) EventHandler(object,event,mesh,P,P_,N_));
set(fig,'KeyPressFcn',@(object,event) EventHandler(object,event,mesh,P,P_,N_));

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
N_ = EventHandler();

end

function [N_] = EventHandler(object,event,mesh,P,P_,N_)
persistent NData;
persistent i;
persistent KDTree;
if( nargin == 0 )
    N_ = NData;
    clear NData i KDTree;
    return;
end
if( isempty(NData) )
    NData = N_;
end
if( isempty(KDTree) )
    KDTree = KDTreeSearcher(P);
end
if(isfigure(object))
    if(( strcmpi(event.Key,'x') || strcmpi(event.Key,'y') || strcmpi(event.Key,'z') ))
        theta = pi/32;
        if( strcmpi(event.Modifier,'control') )
            theta = -theta;
        end
        n = [NData(i,:) 0]';
        if( strcmpi(event.Key,'x') )
            n = (RotX(theta,'matrix') * n)';      
        end
        if( strcmpi(event.Key,'y') )
            n = (RotY(theta,'matrix') * n)';
        end
        if( strcmpi(event.Key,'z') )
            n = (RotZ(theta,'matrix') * n)';
        end
        NData(i,:) = n(:,1:3);
        NData = reorient_plane(P_,NData,P);
    end
end
if(ispatch(object))
    x = event.IntersectionPoint;
    i = knnsearch(KDTree, x, 'K', 1);
end
if( ~isempty(i) )
    delete(get(gca,'Children'));
    hold on;
    point3(P(i,:),20,'r','filled');
    point3(P_(i,:),20,'g','filled');
    plane3(P_(i,:),NData(i,:),1,[1 1 0 0.2],'Parent',handle(gca));
    hold off;
end
mesh.FaceColor     = 'interp';
mesh.FaceVertexCData = normal2color(NData);
end