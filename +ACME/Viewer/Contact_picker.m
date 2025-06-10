function [P_,N_,W_] = Contact_picker(P,N,T,C,verbose,P_)
if(( nargin < 6 ) || isempty(P_))
    P_ = [];
end
if( nargin < 5 || isempty(verbose))
    verbose = false;
end
fig  = CreateViewer3D();
mesh = display_mesh(P,N,T,[0.5 0.5 0.5],'wired');
mesh.HandleVisibility = 'off';
for c = 1 : row(C)
    display_border(C{c}.P,[],C{c}.E,'Color','r');
end

set(mesh,'ButtonDownFcn',@(object,event) VertexSelectionHandler(object,event,P,P_));

run = true;
while( run )
    if(~isvalid(fig))
        break;
    end
    char = get(fig, 'CurrentCharacter');
    if( char == 13 )
        run = false;
    end
    drawnow;
end
P_    = VertexSelectionHandler();
i     = find(cellfun(@(c) isempty(c),P_));
P_(i) = num2cell(P(i,:),2);
X     = cell2mat(P_);

P_      = cell2mat(cellfun(@(c) c.P,C,'UniformOutput',false));
N_      = cell2mat(cellfun(@(c) c.U,C,'UniformOutput',false));
W_      = cell2mat(cellfun(@(c) c.W,C,'UniformOutput',false));
KDTree  = KDTreeSearcher(P_);
I       = knnsearch(KDTree,X,'K',1);

P_ = P_(I,:);
N_ = normr(cross(cross(P-P_,N_(I,:),2),N_(I,:),2));
W_ = W_(I,:);
N_ = reorient_plane(P_,N_,P);
end


% function [P_] = VertexSelectionHandler(object,event,P,P_)
% persistent KDTree;
% persistent CData;
% persistent i Pi Pj;
% delete(Pi);
% delete(Pj);
% if( isempty(KDTree) )
%     KDTree = KDTreeSearcher(P);
% end
% if( isempty(CData) )
%     CData = cell(row(P),1);
%     if( ~isempty(P_) )
%         if(iscell(P_))
%             CData = P_;
%         else
%             CData = num2cell(P_,2);
%         end
%     end
% end
% if( nargin == 0 )
%     P_ = CData;
%     clear KDTree CData i Pi Pj;
%     return;
% end
% x = knnsearch(KDTree, event.IntersectionPoint, 'K', 1);
% % if( strcmpi(get(get_patch_figure(object),'SelectionType'),'alt') )
% if( isRightClick() )
%     if(~isempty(i))
%         CData(i) = num2cell(repmat(event.IntersectionPoint,numel(i),1),2);
%     end
% else
%     i = x;
% end
% hold on;
% Pi = point3(P(i,:),20,'r','filled');
% if( ~isempty(cell2mat(CData(i))) )
%     hold on;
%     Pj = point3(cell2mat(CData(i)),20,'g','filled');
% end
% % k = position2color(cell2mat(CData));%double(cellfun(@(c) isempty(c),CData));
% % object.FaceColor       = 'interp';
% % object.FaceVertexCData = k;
% hold off;
% end



function [P_] = VertexSelectionHandler(object,event,P,P_)
persistent CData;
persistent KDTree;
persistent X;
persistent i;
persistent CPoint VPoint;
if( nargin == 0 )
    P_ = CData;%cellfun(@(d) mean(d,1), CData, 'UniformOutput', false);
    clear CData KDTree X i CPoint VPoint;
    return;
end  

if( isempty(CData) )
    CData = cell(row(P),1);
    if( ~isempty(P_) )
        if(iscell(P_))
            CData = P_;
        else
            CData = num2cell(P_,2);
        end
    end
end
if( isempty(KDTree) )
    KDTree = KDTreeSearcher(P);
end
x = event.IntersectionPoint;
if( isRightClick() )
    X = x;
    i = [];
else
    if( isempty(X) )
        return;
    end
    v        = knnsearch(KDTree, x, 'K', 1);
    CData{v} = mean([CData{v};X],1);
    i = unique([i;v]);
end

delete(CPoint);
delete(VPoint);
hold on;
CPoint = point3(X,20,'r','filled','MarkerEdgeColor','k');
if( ~isempty(i) )
    hold on;
    VPoint = point3(P(i,:),20,'g','filled','MarkerEdgeColor','k');
end
k = position2color(cell2mat(CData));%double(cellfun(@(c) isempty(c),CData));
object.FaceColor       = 'interp';
object.FaceVertexCData = k;
hold off;
end

