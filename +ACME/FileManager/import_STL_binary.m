function [P, N, T] = import_STL_binary(filename, verbose)
if(nargin<2)
    verbose = false;
end
[P,N,T] = import_from_file(filename,'stl',@readDataFcn,verbose);
end

function [P,N,T] = readDataFcn(fileID)
header = fread(fileID, [1 80], 'uint8', 0);
n = fread(fileID, 1, 'uint32', 0);
P = zeros(3*n, 3);
N = zeros(n, 3);
for i = 1 : n
    j = (i-1)*3+1;
    N(i,:) = fread(fileID, [1, 3], 'single', 0, 'l');
    P(j:j+2, :) = fread(fileID, [3 3], 'single', 0, 'l');
    % P = [P; fread(fileID, [3 3], 'single')];
    count = fread(fileID, 1, 'uint16', 0);
end
N = repelem(N, 3, 1);
T = ind2poly(1:row(P), 3);
end

