function plot_timings()
filename = 'Data/Timings.txt';
fileID = fopen(filename,'r');
D = fscanf(fileID,'%f %f %f\n',[3 Inf])';
fclose(fileID);
% D = [D(:,1) D(:,3)];
V = unique(D(:,1));
S = cell2mat(cellfun(@(v) median(D(D(:,1)==v,3)),num2cell(V),'UniformOutput',false));
C = cell2mat(cellfun(@(v) median(D(D(:,1)==v,2)),num2cell(V),'UniformOutput',false));

x  = linspace(0,1,row(V))';
xq = linspace(0,1,100*row(V))';
method = 'pchip';
v  = interp1(x,V,xq,method);
s  = interp1(x,S,xq,method);
c  = interp1(x,C,xq,method);


fig = figure('Name','Preprecessing times','NumberTitle','off');
plot3(v,s,c);
title('Preprocessing timings');
xlabel('Number of Vertices');
zlabel('Number of Curves');
ylabel('Time in seconds');
box on;
% grid on;
view(2);
print(fig,'Img/Operator/Timings.eps','-depsc');
end