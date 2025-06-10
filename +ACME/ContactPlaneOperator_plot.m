function ContactPlaneOperator_plot()
Op = {ContactPlaneOperator.PureContact(256,1),...
      ContactPlaneOperator.Bulge(256,1),...
      ContactPlaneOperator.SoftWrinkle(256,1),...
      ContactPlaneOperator.HardWrinkle(256,1)};
  
fig = figure('Name','Contact Plane Operator',...
             'NumberTitle','off',...
             'WindowState','maximized');

ax = [];
for i = 1 : numel(Op)
    ax = [ax;subplot(1,numel(Op)+1,i)];
    plot_contact_operator(ax(end),Op{i});
%     xlabel(ax(end),'');
    xticks(ax(end),linspace(1,col(Op{i}.Alpha),3));
    xticklabels(ax(end),cellstr(num2str(linspace(0,1,3)'))');
%     ylabel(ax(end),'');
    yticks(ax(end),linspace(1,row(Op{i}.Alpha),3));
    yticklabels(ax(end),cellstr(num2str(linspace(1,0,3)'))');
    colorbar off;
end
ax = [ax;subplot(1,numel(Op)+1,i+1)];
pos = get(ax(end),'Position');
set(ax(end),'Visible','off');
colorbar(ax(end),...
    'Position',[pos(1) 0.37 0.01 0.28],...
    'Ticks',[-1 0 1],...
    'TickLabels',{'min','0','max'},...
    'TickDirection','out');
caxis([-1 1]);

print('Img/Operator/Operator.eps', '-depsc');
  
end