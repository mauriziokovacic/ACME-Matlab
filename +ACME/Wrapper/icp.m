function [X,R,t] = icp(X,Y,iteration)
if(nargin<3)
    iteration = 100;
end
X = make_row(X);
Y = make_row(Y);
p = min(col(X),col(Y));
if(col(X)~=col(Y))
    error('Point dimensionality mismatch.');
end
KDTree = KDTreeSearcher(Y');
t      = cell(iteration+1,1);
R      = cell(iteration+1,1);
t{1}   = [0;0;0];
R{1}   = eye(3);
i      = randperm(p,floor(p/10));

%%%%%%%%%%%%%%%%%%%%%%%
T = evalin('base','T');
CreateViewer3D('right');
display_mesh(Y',vertex_normal(Y',T),T,[Blue() 0.2]);
h = display_mesh(X',vertex_normal(X',T),T,Red());
%%%%%%%%%%%%%%%%%%%%%%%

for n = 1 : iteration
    j             = knnsearch(KDTree,X(:,i)','K',1);
    Y_bar         = Y(:,j);
%     Y_bar = Y;
    [~,R{n+1},t{n+1}] = shape_match(X(:,i),Y_bar);
    X = R{n+1}*X+t{n+1};
    %%%%%%%%%%%%%%%%%%%%%%%
    h.Vertices = X';
    h.VertexNormals = vertex_normal(X',T);
    pause(0.01);
    %%%%%%%%%%%%%%%%%%%%%%%
end
X = X';
end

function [X,R,t] = shape_match(X,Y)
% Compute mean
x_hat = mean(X,2);
y_hat = mean(Y,2);

% De-mean point sets
x_bar = X-x_hat;
y_bar = Y-y_hat;

% Compute covariance
C = x_bar*y_bar';

% Spectral decomposition
[U,~,V] = svd(C);

% Compute optimal rotation
R = V' * (eye(3).*[1;1;det(V'*U')]) * U';

% Compute optimal translation
t = y_hat-R*x_hat;

% Apply transformation
X = R*X+t;
end