function [ax] = SkinningStep(fig,Skin,Frame,type,varargin)
% persistent txt;
% if( isempty(txt) )
%     txt = annotation('textbox','String','','Position',[0.89 0.95 0.11 0.05],'FitBoxToText','off');
% end
% persistent ptc;
% if( isempty(ptc) )
%     ptc = mesh;
% end
persistent C;
pippo = 'face';
delete(C);
ax = get(fig,'Children');
ax = ax(isaxes(ax));
ptc = get(ax,'Children');
if(iscell(ptc))
    cellfun(@(h) delete(h(~islight(h))), ptc);
else
    arrayfun(@(h) delete(h(~islight(h))), ptc);
end
T = Skin.M.S;

if( strcmp(type,'LBS') )
    tic;
    [P,N] = Skin.LBS(Frame);
    N = vertex_normal(P,T);
    fps = time2fps(toc);
    display_mesh(P,N,T,[],pippo);
end

if( strcmp(type,'DQS') )
    tic;
    [P,N] = Skin.DQS(Frame);
%     N = vertex_normal(P,T);
    fps = time2fps(toc);
    display_mesh(P,N,T,[],pippo);
end

if( strcmp(type,'COR') )
    tic;
    [P,N,C] = Skin.COR(Frame,varargin{1});
%     N = vertex_normal(P,T);
    fps = time2fps(toc);
    display_mesh(P,N,T,[],pippo);
end

if( strcmp(type,'MAYA') )
    tic;
    [P,N] = Skin.MAYA(Frame);
%     N = vertex_normal(P,T);
    fps = time2fps(toc);
    display_mesh(P,N,T,[],pippo);
end

if( strcmp(type,'CPS') )
    tic;
    [P,N,P_,N_] = Skin.CPS(Frame,varargin{:});
    N = vertex_normal(P,  T);
    fps = time2fps(toc);
    h = display_mesh(P,N,T,[],pippo);
%     hold on;
%     i = 2058;%[8400];
%     point3(P(i,:),20,'filled','r');
%     plane3(P_(i,:),N_(i,:),0.2.*mesh_scale(P),[1 1 0 0.2]);
set(handle(gcf),'Name',[type,':',num2str(fps),' FPS']);
caxis([-1 1]);
end

if( strcmp(type,'DIV') )
P = Skin.M.P;
N = Skin.M.N;
[PP,NN] = Skin.LBS(Frame);
[PPP,NNN] = Skin.CPS(Frame,varargin{1});
ax = [];
ax = [ax;subplot(1,2,1)];
NN = vertex_normal(PP,T);
display_mesh(PP,NN,T,[],pippo);
CreateAxes3D(ax(end));

ax = [ax;subplot(1,2,2)];
NNN = vertex_normal(PPP,T);
display_mesh(PPP,NNN,T,[],pippo);
CreateAxes3D(ax(end));

% display_mesh(P,N,T,vecnorm3(PP-PPP));

end

end