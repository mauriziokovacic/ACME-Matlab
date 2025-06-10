function [h] = plane2(P,N,side,color)
x = @(p) p(:,1);
y = @(p) p(:,2);
f = @(p,t,c) [c(p)+c(t) c(p)-c(t)]';
if( nargin < 4 )
    color = [1 0 0];
end
if( nargin < 3 )
    side = 10;
end
if( size(color,1) > 1 )
    color=color(1,:);
end
if( numel(color)==1 )
    color = color*ones(1,3);
end
if( size(color,2)==4 )
    color = color(:,1:3);
end

T = [-N(:,2) N(:,1)];
T = side * 0.5 * T;

X = f(P,T,x);
Y = f(P,T,y);
h = line2([X,Y], 'Color', color);
% hold on;
% point2(P,10,[0 0 0],'MarkerFaceColor','flat');
% hold on;
% quiver3(P(:,1),P(:,2),P(:,3),N(:,1),N(:,2),N(:,3),2);
end