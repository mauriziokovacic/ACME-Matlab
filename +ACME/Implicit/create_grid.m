function [G] = create_grid(siz, C, V)
L = grid_Laplacian(siz(1), siz(2));
G = zeros(siz);
for i = 1 : siz(3)
    G(:,:,i) = create_slice(siz(1:2), L, C{i}, V{i});
end
end

function [S] = create_slice(siz, L, C, V)
% Creates the border constraints
c = [sub2ind(siz, ones(1,siz(2)), 1:siz(2))';...            % first row
     sub2ind(siz, repmat(siz(1), 1, siz(2)), 1:siz(2))';... % last row
     sub2ind(siz, 1:siz(1), ones(1,siz(1)))';...            % first col
     sub2ind(siz, 1:siz(1), repmat(siz(2), 1, siz(1)))';... % last col
     sub2ind(siz, 1:siz(1), 1:siz(2))';...
     ];   
v = [linspace(0,1,siz(2))';...
     ones(siz(2),1);...
     linspace(0,1,siz(1))';...
     ones(siz(1),1);...
     linspace(0,1,siz(1))';...
     ];
[c, i] = unique(c);
v      = v(i);

% Substitute the with given constraints
if ~isempty(C)
    C = sub2ind(siz, C(:, 1), C(:, 2));
end
[c, i] = setdiff(c, C);
v      = v(i);

% Build the full constraints
c = [c; C];
v = [v; V];
S = zeros(siz);
S(c) = v;

% Solve the system
M = add_constraints(L, c);
S(:) = M \ S(:);
end