function [K] = align_curve(C,n,varargin)
T    = cell(numel(C),1);
T{1} = linspace(0,1,n);
P    = fetchData(C(1),{'Point'},T{1},varargin{:});
for i = 2 : numel(C)
    [A,B] = C(i).segment();
    t     = C(i).parameter();
    t     = [t(1:end-1) t(2:end)];
    T{i}  = zeros(1,n);
    for j = 1 : row(P)
        [Q,alpha] = project_point_on_segment(A,B,P(j,:));
        k         = min_index(distance(Q,P(j,:),2));
        T{i}(j)   = (1-alpha(k)) * t(k,1) + alpha(k) * t(k,2);
        P(j,:)    = Q(k,:);
%         dt = (1-alpha(k)) * t(k,1) + alpha(k) * t(k,2);
%         dt = dt+linspace(0,1,n);
%         dt(dt>1) = dt(dt>1)-floor(dt(dt>1));
%         T{i} = dt;
    end
end

K = [];
for i = 1 : numel(C)
    [P,N] = fetchData(C(i),{'Point','Normal'},T{i},varargin{:});
    E = curveEdge(row(P));
%     if( is_closed(C(i)) )
%         E(end) = E(1);
%         P = P(1:end-1,:);
%         N = N(1:end-1,:);
%     end
    K = [K;OrientedCurve('Point',P,...
                         'Edge',E,...
                         'Name',C(i).Name,...
                         'Normal',N)];
end

% 
% [a,b] = cc(2).extract_segments();
% theta = cc(2).parameter();
% theta = [theta(1:end-1) theta(2:end)];
% n = 20;
% beta = [];
% gamma = [];
% for t = linspace(0,1,n)
%     x = c.from_param(t);
%     [y,alpha] = project_point_on_segment(a,b,x);
%     i = min_index(distance(y,x,2));
%     gamma = [gamma; y(i,:)];
%     beta = [beta;(1-alpha(i)) * theta(i,1) + alpha(i)*theta(i,2)];
% end
end