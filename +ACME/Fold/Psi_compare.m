function [h,f] = Psi_compare(P,N,T,W,rho)
X = 620;
Y = 700;
f = figure('Position',[1,1,X,Y]);
lim = repmat([min(min(P)) max(max(P))],1,3);
n    = numel(W)+1;
m    = numel(W)+1;
ax   = [];
data = cell(n,m);
for i = 1 : numel(W)
    W{i} = Phi(W{i});
end
for i = 1 : numel(W)
    % Phi
    data{1,i+1} = W{i};
    data{i+1,1} = W{i};
    % Psi
    for j = 1 : numel(W)
        data{i+1,j+1} = Psi(W{i},W{j},rho);
    end
end
for i = 1 : n
    for j = 1 : m
        k  = sub2ind([n m],i,j);
        ax = [ax;subplot(n,m,k)];
        display_mesh(P,N,T,data{i,j});
        caxis([0 1]);
        camlight('right');
        CreateAxes3D(ax(end));
    end
end

h = connect_axes(ax);
set(ax,'Clipping','on');
axis(ax,lim);

p = [ax(  1).Position;...
     ax(  2).Position;...
     ax(n+1).Position];
x  = (p(1,1)+p(1,3)+p(3,1))*0.5;
y  = (p(1,2)+p(2,2)+p(2,4))*0.5;
annotation('line',[0 1],[y y]);
annotation('line',[x x],[0 1]);
end