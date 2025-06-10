function operator_comparison_plot(GBO,CPO)


fig = figure('Name','Operator Comparison',...
             'NumberTitle','off',...
             'MenuBar','none',...
             'ToolBar','none');
         
ci = cmap('implicit',256);
cj = cmap('blue',256);

mat2plane(GBO,[0 1;0 1],'LineColor','flat','LevelList',linspace(0,1,256));
colorbar('Ticks',[0 0.5 1],'FontSize',16);
colormap(ci);
caxis([0 1]);
axis equal
hold on;
mat2plane(GBO,[0 1;0 1],'Fill','off');
mat2plane(GBO,[0 1;0 1],'Fill','off','LevelList',0.5,'LineColor','g','LineWidth',2);
% title('[Canezin et al. 2013] Bulge Operator');
% xlabel('$\mathcal{F}_{1}(\mathbf{v})$','interpret','latex','FontSize',12);
% ylabel('$\mathcal{F}_{2}(\mathbf{v})$','interpret','latex','FontSize',12);
box on;
xticks([]);
yticks([]);

print(fig,'Img/Operator/Canezin.eps','-depsc');

close(fig);

fig = figure('Name','Operator Comparison',...
             'NumberTitle','off',...
             'MenuBar','none',...
             'ToolBar','none');

mat2plane(CPO,[0 1;0 1],'LineColor','flat','LevelList',linspace(-1,1,256));
colorbar('Ticks',[-1 0 1],'FontSize',16);
colormap(cj);
caxis([-1 1]);
axis equal
hold on;
mat2plane(CPO,[0 1;0 1],'Fill','off','LevelList',linspace(0,1,11));
% title('Contact Plane Bulge Operator');
% xlabel('$\Lambda_{\mathbf{v}}$','interpret','latex','FontSize',16);
% ylabel('$\Phi_{\mathbf{v}}$','interpret','latex','FontSize',16);
box on;
xticks([]);
yticks([]);


print(fig,'Img/Operator/Bulge.eps','-depsc');
close(fig);

end