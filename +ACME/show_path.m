h = figure;
for i = 1 : 100
clf(h);
line3(path_NN(1:i,:) ,'Color',[1 0 0],'Marker','x'); hold on;
quiv3([0 0 0],path_NN(i,:),'Color',[1 0 0]); hold on;

line3(path_NN_(1:i,:),'Color',[0 1 0],'Marker','x'); hold on;
quiv3([0 0 0],path_NN_(i,:),'Color',[0 1 0]); hold on;

line3(path_X(1:i,:),'Color',[0 0 1],'Marker','x'); hold on;
quiv3([0 0 0],path_X(i,:),'Color',[0 0 1]); hold on;

line3(path_FF_(1:i,:),'Color',[1 0 1],'Marker','x'); hold on;
quiv3([0 0 0],path_FF_(i,:),'Color',[1 0 1]); hold on;


line3(path_NNN(1:i,:),'Color',[1 1 0],'Marker','x'); hold on;
quiv3([0 0 0],path_NNN(i,:),'Color',[1 1 0]); hold on;
% line3(path_A(1:i,:),'Color',[1 1 0],'Marker','x'); hold on;
% quiv3([0 0 0],path_A(i,:),'Color',[1 1 0]); hold on;


line3(path_nn(1:i,:),'Color',[0 1 1],'Marker','x'); hold on;
quiv3([0 0 0],path_nn(i,:),'Color',[0 1 1]);

axis equal
axis([-1 1 -1 1 -1 1]);

ax = get(h,'CurrentAxes');
set(ax,'CameraTarget',[0 0 0]);
set(ax,'CameraPosition',[-1 1 1]);
set(ax,'Clipping','off');

pause(0.1);
end

rotate3d on;









