function [P_,N_,W_] = ContactViewer3D(P,N,T,C,P_,multi_pick)
if( nargin < 6 || isempty(multi_pick) )
    multi_pick = true;
end
G    = graph(Adjacency(P,T,'length'));
fig  = CreateViewer3D('Name','Contact Viewer','right');
mesh = display_mesh(P,N,T,[0.5 0.5 0.5],'wired');
mesh.HandleVisibility = 'off';
for c = 1 : row(C)
    display_border(C{c}.P,[],C{c}.E,'Color','r');
end
set(mesh,'ButtonDownFcn',@(object,event) EventHandler(object,event,P,G,P_,multi_pick));
run = true;
while( run )
    if( ~isvalid(fig) )
        EventHandler();
        return;
    end
    char = get(fig, 'CurrentCharacter');
    if( char == 13 )
        run = false;
    end
    drawnow;
end
P_    = EventHandler();
i     = find(cellfun(@(c) isempty(c),P_));
P_(i) = num2cell(P(i,:),2);
X     = cell2mat(P_);

P_      = cell2mat(cellfun(@(c) c.P,C,'UniformOutput',false));
KDTree  = KDTreeSearcher(P_);
I       = knnsearch(KDTree,X,'K',1);

P_      = P_(I,:);

N_      = cell2mat(cellfun(@(c) c.U,C,'UniformOutput',false));
N_      = normr(cross(cross(P-P_,N_(I,:),2),N_(I,:),2));
% N_      = cell2mat(cellfun(@(c) c.N,C,'UniformOutput',false));
% N_      = N_(I,:);
N_ = reorient_plane(P_,N_,P);

W_      = cell2mat(cellfun(@(c) c.W,C,'UniformOutput',false));
W_      = W_(I,:);

if( isvalid(fig) )
    close(fig);
end

end


function [P_] = EventHandler(object,event,P,G,P_,multi_pick)
persistent KDTree;
persistent Path;
persistent X i j;
persistent CData;
persistent CPoint VPoint;

if( nargin == 0 )
    P_ = cellfun(@(c) mean(c,1), CData, 'UniformOutput', false);
    clear KDTree Path X i j CPoint VPoint CData;
    return;
end
if( isempty(KDTree) )
    KDTree = KDTreeSearcher(P);
end
if( isempty(CData) )
    CData = cell(row(P),1);
    if( ~isempty(P_) )
        if(iscell(P_))
            CData = P_;
        else
            CData = num2cell(P_,2);
        end
    else
        CData = num2cell(P,2);
    end
end

x = event.IntersectionPoint;
v = knnsearch(KDTree, x, 'K', 1);
if( isRightClick() )
    X = x;
    j = v;
    i = [];
else
    i = v;
end
delete(CPoint);
delete(VPoint);

hold on;
CPoint = point3(X,20,'r','filled','MarkerEdgeColor','k');
exec = false;
if( ~isempty(i) )
    hold on;
    VPoint = point3(P(i,:),20,'g','filled','MarkerEdgeColor','k');
    if( multi_pick )
        if( ~isempty(j) )
            Path = shortestpath(G,i,j);
            exec = true;
        end
    else
        Path = i;
        exec = true;
    end
end
if( exec )
    for k = 1 : numel(Path)
        CData{Path(k)} = [CData{Path(k)};X];
    end
    delete(VPoint);
    hold on;
    VPoint = point3(P(Path,:),20,'g','filled','MarkerEdgeColor','k');
end

hold off;
k = position2color(cell2mat(cellfun(@(c) mean(c,1), CData, 'UniformOutput', false)));%double(cellfun(@(c) isempty(c),CData));
object.FaceColor       = 'interp';
object.FaceVertexCData = k;
hold off;
end