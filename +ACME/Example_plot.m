function Example_plot()
fig = figure('Name','Example',...
             'NumberTitle','off',...
             'WindowState','maximized');
         
P   = [linspace(0,1,11)',zeros(11,2)];
PP  = P;
N   = repmat([0 1 0], row(P),1);
P_  = zeros(size(P));
N_  = repmat([1 0 0],row(P),1);
I   = linspace(1,0,row(P))'.^0.5;
NN_ = repmat(normr([1 -1 0]),row(P),1);
Op  = ContactPlaneOperator.HardWrinkle(256,1);


ax = subplot(1,4,1);
line2([0 0;0 0.8],'LineWidth',3,'Color','r');
hold on;
path3(P+[zeros(row(P),1) linspace(0,0.3,row(P))' zeros(row(P),1)],[0.8 0.8 0.8]);
hold on;
path3(P,'k');
hold on;
% quiv3([0 0.5 0],N_(1,:),'Color','y');
axis equal;
axis tight;
axis([0 1 -0.2 0.8 0 1]);
box on;
xticks([]);
yticks([]);
title(ax,'Direct Skinning','Interpret','latex');
xlabel('(a)');
annotation(fig,'arrow',[0.23 0.235],[0.47 0.44],'Color',[0.5 0.5 0.5]);
% text(P(4,1),P(4,2)-0.05,'v');

ax = subplot(1,4,2);
line2([0 0;[0 0.8]],'LineWidth',3,'Color',[1 0.8 0.8]);
hold on;
line2([0 0;normr([1 1])*0.8],'LineWidth',3,'Color','r');
hold on;
path3(P,'k');
hold on;
% quiv3([0 0.5 0],N_(1,:),'Color','y');
axis equal;
axis tight;
axis([0 1 -0.2 0.8 0 1]);
box on;
xticks([]);
yticks([]);
xlabel('(b)');
title(ax,'Update Planes','Interpret','latex');
annotation(fig,'arrow',[0.34 0.38],[0.58 0.53],'Color',[1 0.5 0.5]);
% text(P(4,1),P(4,2)-0.05,'v');


ax = subplot(1,4,3);
plot_contact_operator(ax,Op);
% title(ax,'Operator');
% xticks(ax,linspace(1,col(Op.Alpha),3));
% xticklabels(ax,cellstr(num2str(linspace(0,1,3)'))');
% yticks(ax,linspace(1,row(Op.Alpha),3));
% yticklabels(ax,cellstr(num2str(linspace(1,0,3)'))');
title('');
xticks([]);
yticks([]);
xlabel('(c)');
ylabel('');
colorbar off;
cmap('blue',256);
annotation(fig,'textarrow',repmat(0.575,1,2),[0.5 0.6],'String','\Phi_v');
annotation(fig,'textarrow',[0.62 0.58],repmat(0.61,1,2),'String','\Lambda_v');
annotation(fig,'rectangle',[0.57 0.6 0.01 0.02],'Color','r','LineWidth',2);
title(ax,'Fetch Operator $\mathcal{F}(\Lambda_{v},\Phi_{v})$','interpret','latex');





ax = subplot(1,4,4);

[PP,NN] = Contact_Plane_Skinning(P,N,PP,N,P_,N_,P_,NN_,I,Op);
PP = PP.*[1 5 0];

line2([0 0;normr([1 1])*0.8],'LineWidth',3,'Color','r');
hold on;
path3(P,[0.8 0.8 0.8]);
hold on;
path3(PP,'k');
axis equal;
axis tight;
axis([0 1 -0.2 0.8 0 1]);
box on;
xticks([]);
yticks([]);
xlabel('(d)');
title(ax,'Apply Deformation','Interpret','latex');
% text(PP(4,1),PP(4,2)-0.05,'v');

print('Img/Operator/Example.svg', '-dsvg');
print('Img/Operator/Example.eps', '-depsc');


end