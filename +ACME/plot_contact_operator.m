function [fig] = plot_contact_operator(varargin)
fig = [];
ax  = [];
if( nargin == 0 )
    Op = 256;
else
    j = 1;
    if( isfigure(varargin{j}) )
        fig = varargin{j};
        ax  = get(fig,'CurrentAxes');
        if( dimension(ax) == 0 )
            ax = axes;
        end
        j = 2;
    else
        if( isaxes(varargin{j}) )
            ax  = varargin{j};
            fig = get(ax,'Parent');
            j = 2;
        else
            fig = figure('Name','Contact Plane Operator',...
                         'NumberTitle','off',...
                         'MenuBar','none',...
                         'ToolBar','none');
            ax = axes;
        end
    end
    if( nargin-j < 0 )
        Op = 256;
    else
        Op = varargin{j};
    end
end

if( ~isa(Op,'ContactPlaneOperator') && dimension(Op)==1 )
    Op = ContactPlaneOperator.Default(Op,1);
end
txt = Op.Name;
Op  = Op.Alpha';
Op  = flipud(Op);
% Op  = matresize(Op,[256 256]);
imagesc(ax,Op);
% mat2plane(Op,[0 1; 0 1],'EdgeColor','none','LevelList',linspace(-1,1,256));
colorbar;
cmap('blue',16);
box on;
axis equal;
axis tight;
axis([1 col(Op) 1 row(Op)]);
caxis([-1 1]);
title(ax,strcat('\bf ', txt),'interpret','tex');
xlabel(ax,'\Lambda','FontSize',14);
xticks(ax,linspace(1,col(Op),11));
xticklabels(ax,cellstr(num2str(linspace(0,1,11)'))');
ylabel(ax,'\Phi','FontSize',14);
yticks(ax,linspace(1,row(Op),11));
yticklabels(ax,cellstr(num2str(linspace(1,0,11)'))');
end