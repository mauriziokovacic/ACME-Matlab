function [t] = plot_number(P,T,type,varargin)
if( nargin < 3 )
    type = 'v';
end

type = lower(type);

if( strcmp(type,'v') || strcmp(type,'vert') || strcmp(type,'vertex') || strcmp(type,'a') || strcmp(type,'all') )
    t = text3(P,num2str((1:size(P,1))'),varargin{1:end});
    return;
end

if( strcmp(type,'f') || strcmp(type,'t') || strcmp(type,'face') || strcmp(type,'triangle') || strcmp(type,'a') || strcmp(type,'all') )
    X = triangle_barycenter(P,T)+triangle_normal(P,T)*0.1;
    t = text3(X,num2str((1:size(X,1))'),varargin{1:end});
end

if( strcmp(type,'e') || strcmp(type,'edge') || strcmp(type,'a') || strcmp(type,'all') )
    I = T(:,1);
    J = T(:,2);
    K = T(:,3);
    E = unique( sort( [I J; J K; K I], 2 ), 'rows' );
    X = (P(E(:,1),:) + P(E(:,2),:)) ./ 2;
    t = text3(X,num2str((1:size(X,1))'),varargin{1:end});
end

end