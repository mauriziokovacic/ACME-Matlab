function [P,T] = triangle_fan(n,p_norm)
if( nargin < 2 )
    p_norm = 2;
end
if( nargin == 0 )
    n = 4;
end
theta = linspace(0,2*pi,n+1)';
P = [0 0 0;cos(theta),sin(theta),zeros(n+1,1)];
for i = 2 : row(P)
    P(i,:) = P(i,:) / norm(P(i,:),p_norm);
end
T = [ones(n,1) , (2:row(P)-1)', (3:row(P))' ];
end