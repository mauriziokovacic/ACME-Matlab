function [P, N, T] = import_STL_ascii(filename, verbose)
if(nargin<2)
    verbose = false;
end
[P,N,T] = import_from_file(filename,'stl',@readDataFcn,verbose);
end

function [P,N,T] = readDataFcn(fileID)
data = textscan(fileID,'%s','Delimiter',newline);
data = data{1};

data(cellfun(@(c) startsWith(c, 'solid') || ...
                  startsWith(c, 'outer') || ...
                  startsWith(c, 'end'  ), data)) = [];
data = cellfun(@(c) strrep(c, 'facet normal ', ''), data, 'UniformOutput', false);
data = cellfun(@(c) strrep(c, 'vertex ', ''), data, 'UniformOutput', false);
s  = cell2mat(cellfun(@(c) sscanf(c, '%f %f %f', [3 1])', data, 'UniformOutput', false));
n = row(s);
i = (1:n)';
j = (1:4:n)';
i = setdiff(i, j);
N = repelem(s(j, :), 3, 1);
P = s(i, :);
T = ind2poly(1:row(P), 3);
end

