function Psi_plot(rho)
if(nargin==0)
    rho = [0.5 1 2 3];
end
f     = figure('WindowState', 'maximized',...
               'NumberTitle', 'off',...
               'ToolBar', 'none');
n = 100;
[x,y] = meshgrid(linspace(0,1,n),linspace(0,1,n));
for i = 1 : numel(rho)
    f = Psi(x,y,rho(i));
%     ax = subplot(row(rho),col(rho),i);
    ax = subplot(1,numel(rho),i);
    surf(x,y,f,'EdgeColor','none','FaceColor','interp');
    hold on;
    contour3(x,y,f,'LineColor','k');
    view(2);
    title(ax,strcat('\rho = ',num2str(rho(i))));
    axis equal;
    cmap('blue',10);
    caxis([0 1]);
end
colorbar(ax,...
    'Position',[0.93 0.365 0.01 0.305],...
    'Limits',[0 1],...
    'Ticks',[0 0.2 0.4 0.6 0.8 1]);
end