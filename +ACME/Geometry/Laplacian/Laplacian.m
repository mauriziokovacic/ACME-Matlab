function [ L ] = Laplacian( A, varargin )
expectedType = {'std','sym','walk'};
parser = inputParser;
addRequired(parser, 'A',                     @(x) isnumeric(x) && ismatrix(x));
addOptional(parser, 'type', expectedType{1}, @(x) any(validatestring(x,expectedType)));
parse(parser, A, varargin{:});
A    = parser.Results.A;
type = parser.Results.type;
D    = Degree(A);
switch type
    case expectedType{1}
        L = standard(D,A);
    case expectedType{2}
        L = symmetric_normalized(D,A);
    case expectedType{3}
        L = random_walk(D,A);
end
end

function [L] = standard(D, A)
L = D - A;
end

function [L] = symmetric_normalized(D, A)
I  = speye(size(D));
iD = sqrt(spdiags(1 ./ nonzeros(D), 0, row(D), col(D)));
L  = I - iD * A * iD;
end

function [L] = random_walk(D, A)
iD = spdiags(1 ./ nonzeros(D), 0, row(D), col(D));
L  = iD * A;
end