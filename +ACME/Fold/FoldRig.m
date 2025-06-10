function [W] = FoldRig(n,m,I,J,initialGuess)
if(nargin<5)
    initialGuess = [];
end
if((nargin<4)||(nargin<3))
    I = [];
    J = [];
end

% n is a scalar 1x1 indicating the number of vertices
% m is a scalar 1x1 indicating the number of handles
% I is cell containing set of vertices IDs
% J is a cell containing set of handles IDs
% I and J are the same size

% The system might be a standard Ax=b, where
% - A is a (n+c)x(n*m) sparse matrix containing the constraints:
%         n for the classic sum w = 1
%         c user defined from strokes on mesh
%         n*m because we store weights in a linearized fashion
% - x is a (n*m)x1 vector containing the weights, that will be then
%   reshaped into a nxm matrix W
% - b is a ((n+c)*(n*m))x1 vector containing n 1s at the begining, followed
%   by 0.5s till the end

A = [];
b = [];

% Initial guess values
if(~isempty(initialGuess))
%     [i,j,w] = find(initialGuess);
%     A = [A;sparse((1:numel(i))',(i-1)*m+j,1,numel(i),n*m)];
%     b = [b;w];
    
%     [i,j] = find(~logical(initialGuess));
%     A = [A;sparse((1:numel(i))',(i-1)*m+j,1,numel(i),n*m)];
%     b = [b;zeros(numel(i),1)];
%     clear i j w;
    A = [A;speye(n*m)];
    initialGuess = initialGuess';
    b = [b;initialGuess(:)];
    
    [i,j] = find(initialGuess');
    e = unique([i,j],'rows');
    
end

% Partition of unity constraints
A = [A;repelem(speye(n),1,m)];
b = [b;sparse(ones(n,1))];

% Strokes constraints
for C = 1 : numel(I)
    i = make_row(I{C});
    j = make_column(J{C});
    e = sparse(repelem((1:numel(i))',numel(j),1),(i-1)*m+j,1,numel(i),n*m);
    A = [A;e];
    b = [b;repmat(0.5,numel(i),1)];
end
clear C i j e;

% Solve
W = A\b;
W(abs(W)<0.001) = 0;
W = reshape(W,m,n)';
end