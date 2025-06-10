function CylinderFoldExample()
[P,N,T,W,Skel,Anim,DQS] = fetchData();
lim = [min(P(:,1)) max(P(:,1))];
frame = floor(linspace(1,50,4));
color = weight2color(W);


option = [0 0 0 0 0 1];
bar    = option(end);

plots = numel(find(option));
dc    = 0.1/(numel(frame)-1);

b = 'T';
titles = latexTitles(b);
subfor = latexFormulas(b);

b   = ['\mathcal{',b,'}'];
Bi  = latexMath(latexSubScript(b,'i'));
Bj  = latexMath(latexSubScript(b,'j'));




f     = figure('WindowState', 'maximized',...
               'NumberTitle', 'off',...
               'ToolBar', 'none');

l = 2;
           
%{
Rest pose
%}
if(option(1))
ax = CreateAxes3D(subplot(1,plots,1,'align'));
h = display_mesh(P,N,T,[0.8 0.8 0.8],'face',[],'Parent',ax);
uistack(ax,'bottom');
ax.XLim = lim;
ax.YLim = lim;
ax.ZLim = lim;

ax = copy_axes_properties(ax,CreateAxes3D(f));
h = display_mesh(P,N,T,Black(),'wireframe',[],'Parent',ax);
h.LineWidth = l;
uistack(ax,'bottom');

ax = copy_axes_properties(ax,CreateAxes3D(f));
Skel.discardDelta();
h = Skel.show('FaceColor',[0.9 0.9 0.9]);
h(1).EdgeColor = Blue()*0.7;
h(2).EdgeColor = Green();
h(1).FaceColor = [0.4250 0.4250 0.8500];
h(2).FaceColor = [0.4250 0.8500 0.4250];

uistack(ax,'top');

if(plots==numel(option))
figText(f,Bi,ax.Position(1)-0.02,0.535,ax.Position(3));
figText(f,Bj,ax.Position(1)+0.03,0.535,ax.Position(3));
figTitle(f,titles{1},ax.Position(1),ax.Position(3));
figSubTitle(f,subfor{1},ax.Position(1),ax.Position(3));
end
end

%{
Bent pose
%}
if(option(2))
ax = CreateAxes3D(subplot(1,plots,option(1)+1,'align'));
h = display_mesh(P,N,T,[0.9 0.9 0.9],'face',[],'Parent',ax);
ax.XLim = lim;
ax.YLim = lim;
ax.ZLim = lim;
uistack(ax,'bottom');
for i = 1 : numel(frame)-1
    tmp   = Anim{frame(1+i)};
    [p,n] = DQS.deform(tmp);
    ax    = copy_axes_properties(ax,CreateAxes3D(f));
    display_mesh(p,n,T,repmat(0.9-dc*i,1,3),'face',[],'Parent',ax);
    uistack(ax,'top');
end

ax = copy_axes_properties(ax,CreateAxes3D(f));
h = display_mesh(p,n,T,Black(),'wireframe',[],'Parent',ax);
h.LineWidth = l;
uistack(ax,'top');
uistack(ax,'down');

ax   = copy_axes_properties(ax,CreateAxes3D(f));
pose = lin2mat(Anim{frame(end)});
assignCurrentFromRelativePose(Skel,[{pose{1}};{pose{2}};{pose{2}}]);
h = Skel.show('FaceColor',[0.9 0.9 0.9]);
h(1).EdgeColor = Blue()*0.7;
h(2).EdgeColor = Green();
h(1).FaceColor = [0.4250 0.4250 0.8500];
h(2).FaceColor = [0.4250 0.8500 0.4250];
uistack(ax,'top');

if(plots==numel(option))
figText(f,Bi,ax.Position(1)+0.01,0.600,ax.Position(3));
figText(f,Bj,ax.Position(1)+0.04,0.535,ax.Position(3));
figTitle(f,titles{2},ax.Position(1),ax.Position(3));
figSubTitle(f,subfor{2},ax.Position(1),ax.Position(3));
end
end
       
%{
Bi pose
%}
if(option(3))
ax = CreateAxes3D(subplot(1,plots,sum(option(1:2))+1,'align'));
display_mesh(P,N,T,[0.9 0.9 0.9],'face',[],'Parent',ax);
ax.XLim = lim;
ax.YLim = lim;
ax.ZLim = lim;
uistack(ax,'bottom');
for i = 1 : numel(frame)-1
    [p,n] = computePose(DQS,Anim,frame(1+i),'Ti');
    ax    = copy_axes_properties(ax,CreateAxes3D(f));
    h     = display_mesh(p,n,T,repmat(0.9-dc*i,1,3),'face',[],'Parent',ax);
    uistack(ax,'top');
end
h.FaceColor       = 'interp';
h.FaceVertexCData = color;

ax = copy_axes_properties(ax,CreateAxes3D(f));
h = display_mesh(p,n,T,Black(),'wireframe',[],'Parent',ax);
h.LineWidth = l;
uistack(ax,'top');
uistack(ax,'down');

if(plots==numel(option))
figTitle(f,titles{3},ax.Position(1),ax.Position(3));
figSubTitle(f,subfor{3},ax.Position(1),ax.Position(3));
end
end

%{
Bj pose
%}
if(option(4))
ax = CreateAxes3D(subplot(1,plots,sum(option(1:3))+1,'align'));
display_mesh(P,N,T,[0.9 0.9 0.9],'face',[],'Parent',ax);
ax.XLim = lim;
ax.YLim = lim;
ax.ZLim = lim;
uistack(ax,'bottom');
for i = 1 : numel(frame)-1
    [p,n] = computePose(DQS,Anim,frame(1+i),'Tj');
    ax    = copy_axes_properties(ax,CreateAxes3D(f));
    h     = display_mesh(p,n,T,repmat(0.9-dc*i,1,3),'face',[],'Parent',ax);
    uistack(ax,'top');
end
h.FaceColor       = 'interp';
h.FaceVertexCData = color;

ax = copy_axes_properties(ax,CreateAxes3D(f));
h = display_mesh(p,n,T,Black(),'wireframe',[],'Parent',ax);
h.LineWidth = l;
uistack(ax,'top');
uistack(ax,'down');

if(plots==numel(option))
figTitle(f,titles{4},ax.Position(1),ax.Position(3));
figSubTitle(f,subfor{4},ax.Position(1),ax.Position(3));
end
end


%{
Fold pose
%}
if(option(5))
ax = CreateAxes3D(subplot(1,plots,sum(option(1:4))+1,'align'));
display_mesh(P,N,T,[0.9 0.9 0.9],'face',[],'Parent',ax);
ax.XLim = lim;
ax.YLim = lim;
ax.ZLim = lim;
uistack(ax,'bottom');
% close(f);
% f = CreateViewer3D();
for i = 1 : numel(frame)-1
    [p,n] = computePose(DQS,Anim,frame(1+i),'TiTj');
    ax    = copy_axes_properties(ax,CreateAxes3D(f));
    h     = display_mesh(p,n,T,repmat(0.9-dc*i,1,3),'face',[],'Parent',ax);
    h     = display_mesh(p,n,T,repmat(0.9-dc*i,1,3));
    uistack(ax,'top');
end
% set(gca,'Clipping','on');
h.FaceColor       = 'interp';
h.FaceVertexCData = color;

ax = copy_axes_properties(ax,CreateAxes3D(f));
h = display_mesh(p,n,T,Black(),'wireframe',[],'Parent',ax);
h.LineWidth = l;
uistack(ax,'top');
uistack(ax,'down');

if(plots==numel(option))
figTitle(f,titles{5},ax.Position(1),ax.Position(3));
figSubTitle(f,subfor{5},ax.Position(1),ax.Position(3));
end
end
       
%{
Fold position
%}
if(option(6))
k = find(abs(P(:,1))<0.1);
E = tri2edge(T);
E = unique(sort(E,2),'rows');
E = E(logical(prod(ismember(E,k),2)),:);
    
ax = CreateAxes3D(subplot(1,plots,sum(option(1:5))+1,'align'));
display_mesh(P,N,T,[0.8 0.8 0.8],'face',[],'Parent',ax);
ax.XLim = lim;
ax.YLim = lim;
ax.ZLim = lim;
uistack(ax,'bottom');
[p,n] = computePose(DQS,Anim,frame(numel(frame)),'F');
ax = copy_axes_properties(ax,CreateAxes3D(f));
display_mesh(p,n,T,color,'face',[],'Parent',ax);
plane3([0 0.12 0],[1 0 0],max(abs(P(:,2)))*2.15,Red(),'EdgeColor','r','LineWidth',2);
% display_curve(P,E,'EdgeColor','r');
% display_curve(p,E,'EdgeColor','b');



uistack(ax,'top');

ax = copy_axes_properties(ax,CreateAxes3D(f));
h = display_mesh(p,n,T,Black(),'wireframe',[],'Parent',ax);
h.LineWidth = l;
uistack(ax,'top');
uistack(ax,'down');

if(plots==numel(option))
figTitle(f,titles{6},ax.Position(1),ax.Position(3));
figSubTitle(f,subfor{6},ax.Position(1),ax.Position(3));
% annotation(f,'line',...
%     'Color','r',...
%     'Position',[ax.Position(1)+0.5*ax.Position(3) 0.497 0 0.043],...
%     'LineWidth',2);
end
end
       
% connect_figures(f);

if(bar)
colorbar(ax,...
    'Position',[0.82 0.42 0.02 0.45],...[0.92 0.497 0.01 0.11],...
    'Limits',[0 1],...
    'Ticks',[0 0.5 1],...
    'FontSize',16,...
    'TickLabelInterpreter','latex',...
    'TickLabels',{'$\omega_i = 1$','$\omega_i = \omega_j$','$\omega_j = 1$'});
cmap([0.4250 0.8500 0.4250;0.4250 0.4250 0.8500]);
end

print(f, 'C:\Users\Maurizio\Desktop\CapsuleFoldExample.png', '-dpng', '-r300' );
end

function [P,N,T,W,Skel,Anim,DQS] = fetchData()
    name = 'Cylinder';
    path = ['Data/',name,'/'];
    [ P, UV, ~, T ] = import_GEO( [path,'Geometry'] );
    N = vertex_normal(P,T);
    [ W           ] = import_SKN( [path,'Skin'] );
    [Sname,~,Schild,~,~,~,~,ModelPose] = import_SKEL([path,'Skeleton']);
    ModelPose = lin2mat(ModelPose);
    G = skeletonGraph(Schild,'NodeName',Sname);
    Skel = BaseSkeleton.createFromSkeletonPose(G,ModelPose);
    for i = 1 : 100
        Anim{i} = repmat(RotX(0),size(W,2),1);
        Anim{i}(2:end,:) = repmat(RotZ(-(i-1)*pi/(100)),size(W,2)-1,1);
    end
    Anim = cellfun(@(Pose) Pose(1:col(W),:),Anim,'UniformOutput',false')';
    M    = AbstractMesh('Vertex',P,'Normal',N,'UV',UV,'Face',T);
    S    = AbstractSkin('Mesh',M,'Weight',W);
    DQS  = DQSDeformer('Mesh',M,'Skin',S);
end

function [p,n] = computePose(DQS,Anim,frame,type)
pose     = Anim{frame};
pose     = lin2mat(pose);
t        = inv(pose{1});
tbar     = inv(pose{2});
poset    = cellfun(@(m) m*t,pose,'UniformOutput',false);
posetbar = cellfun(@(m) m*tbar,pose,'UniformOutput',false);
W = DQS.Skin.Weight;
switch type
    case 'Tj'
        pose  = poset;
        pose  = mat2lin(pose);
        [p,n] = DQS.deform(pose);
    case 'Ti'
        pose  = posetbar;
        pose  = mat2lin(pose);
        [p,n] = DQS.deform(pose);
    case 'F'
        pose  = [{(posetbar{1}+eye(4))};{(poset{2}+eye(4))}]; % .*0.5
        pose  = mat2lin(pose);
        [p,n] = DQS.deform(pose);
    otherwise
        pose  = [{(posetbar{1}+eye(4))};{(poset{2}+eye(4))}]; % .*0.5
        u = normalize(abs(DQS.Mesh.Vertex(:,1)));
        F    = griddedInterpolant([0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1],...
                                  [0 0   0   0   0   0   0   0   0   0   0], 'pchip','nearest');
        d    = F(u);
        nVert = row(DQS.Mesh.Vertex);
        x = DQS.Mesh.Vertex(:,2)<0;
        p = zeros(nVert,3);
        n = zeros(size(p));
        for v = 1 : nVert
            wi = W(v,1);
            wj = W(v,2);
            titj = pose{1};
            tjti = pose{2};
            if(x(v))
                T  = (wi*titj+wj*tjti);
            else
                dd = d(v);
                di = real(tjti^dd);
                dj = real(titj^dd);
                T  = wi*titj*di+wj*tjti*dj;
            end
            DQ = mat2dq(full(T));
            type = 'dq';
            p(v,:)  = transform_point(DQ,DQS.Mesh.Vertex(v,:),'dq');
            n(v,:)  = transform_normal(DQ,DQS.Mesh.Normal(v,:),'dq');
            n(v,:)  = normr(n(v,:));
        end
        n = vertex_normal(p,DQS.Mesh.Face);
end
% pose  = mat2lin(pose);
% [p,n] = DQS.deform(pose);
DQS.Skin.Weight = W;
end

function [a] = figText(fig,txt,x,y,dx)
a = annotation(fig,'textbox',...
               'Interpreter','latex',...
               'String',txt,...
               'Position',[x y dx 0.03],...
               'EdgeColor','none',...
               'HorizontalAlignment','center');
end

function [a] = figTitle(fig,txt,x,dx)
a = figText(fig,txt,x,0.64,dx);
end

function [a] = figSubTitle(fig,txt,x,dx)
a = figText(fig,txt,x,0.45,dx);
end

function [txt] = latexMath(txt)
txt = ['$',txt,'$'];
end

function [txt] = latexSubScript(txt,sub)
txt = [txt,'_{',sub,'}'];
end

function [txt] = latexSuperScript(txt,sup)
txt = [txt,'^{',sup,'}'];
end

function [txt] = latexInverse(txt)
txt = latexSuperScript(txt,'-1');
end

function [txt] = latexCorrection(txt)
txt = strrep(txt,'$$','');
txt = strrep(txt,'  ',' ');
end

function [txt] = latexTitles(symbol)
b   = ['\mathcal{',symbol,'}'];
Bi  = latexMath(latexSubScript(b,'i'));
Bj  = latexMath(latexSubScript(b,'j'));

txt = cell(1,6);
txt{1} = 'Two-bones capsule in rest pose';
txt{2} = ['Pose after bending ',Bi];
txt{3} = ['Pose expressed considering ',Bi,' fixed'];
txt{4} = ['Pose expressed considering ',Bj,' fixed'];
txt{5} = ['Pose expressed considering both ',Bi,' and ',Bj,' moving'];
txt{6} = 'Folds occurs where $\omega_i=\omega_j$';
end

function [txt] = latexFormulas(symbol)
b   = ['\mathcal{',symbol,'}'];
bi  = latexSubScript(b,'i');
bj  = latexSubScript(b,'j');
bin = latexInverse(bi);
bjn = latexInverse(bj);
Bi  = latexMath(bi);
Bj  = latexMath(bj);
Bin = latexMath(bin);
Bjn = latexMath(bjn);

txt = cell(1,6);
txt{1} = '';
txt{2} = latexCorrection(['$p''=(\omega_i$',Bi,'$+\omega_j$',Bj,'$)p$']);
txt{3} = latexCorrection(['$p''=(\omega_i I+\omega_j$',Bj,Bin,'$)p$']);
txt{4} = latexCorrection(['$p''=(\omega_i$',Bi,Bjn,'$+\omega_j I)p$']);
txt{5} = latexCorrection(['$p''=\frac{1}{2}(\omega_i$',Bi,Bjn,'$+\omega_j$',Bj,Bin,'$+I)p$']);
txt{6} = 'No changes \textit{w.r.t.} rest pose';
end