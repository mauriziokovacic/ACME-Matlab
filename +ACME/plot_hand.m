function h = plot_hand(P,N,T,W,C,U)
c = cell(3,1);
c{1} = U;
c{2} = W*scatter_color(col(W),1:col(W));
for i = 1 : 2
    [f,ax] = PlotHelper(P,N,T,c{i});
    saveas(f,strcat('Img/Hand',num2str(i),'.png'),'png');
    print(f,strcat('Img/Hand',num2str(i),'.eps'),'-depsc');
    close(f);
end
i = i+1;
[f,ax] = PlotHelper(P,N,T,c{i});
for j = 1 : numel(ax)
    axes(ax(j));
    for c = 1 : row(C)
        display_border(C{c}.P,[],C{c}.E,'Color','r','LineWidth',3);
    end
end
saveas(f,strcat('Img/Hand',num2str(i),'.png'),'png');
close(f);

end


function [f,ax] = PlotHelper(P,N,T,c)
f  = figure;
set(f,'WindowState','maximized');
ax = [];
ax = [ax;subplot(2,1,2)];
display_mesh(P,N,T,c);
CreateAxes3D(ax(end));
view(0,0);
pos = get(ax(end),'CameraPosition');
trg = get(ax(end),'CameraTarget');
camlight('headlight');

ax = [ax;subplot(2,1,1)];
display_mesh(P,N,T,c);
CreateAxes3D(ax(end));
set(ax(end),'XDir','reverse');
set(ax(end),'CameraTarget',trg);
set(ax(end),'CameraPosition',pos+2*(trg-pos));
camlight('headlight');


h = linkprop(ax,...
{'XScale',...
'YScale',...
'ZScale',...
'XLim',...
'YLim',...
'ZLim',...
'CameraPositionMode',...
'CameraTarget',...
'CameraTargetMode',...
'CameraUpVector',...
'CameraUpVectorMode',...
'CameraViewAngle',...
'CameraViewAngleMode',...
'Clipping',...
'ClippingStyle'});
end