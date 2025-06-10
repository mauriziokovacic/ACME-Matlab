function [X] = ParticleSwarmOptimization(varargin)
parser = inputParser;
addRequired( parser, 'InputSize',               @(data) isscalar(data) );
addRequired( parser, 'GoalFcn',                 @(data) isa(data,'function_handle'));
addParameter(parser, 'InitialGuess',        [], @(data) isnumeric(data) );
addParameter(parser, 'FeasibleFcn',      @(x)x, @(data) isa(data,'function_handle'));
addParameter(parser, 'SwarmSize',           10, @(data) isscalar(data));
addParameter(parser, 'Iteration',           10, @(data) isscalar(data));
addParameter(parser, 'PhiVector',    ones(3,1), @(data) isnumeric(data)&&row(data)==3);
parse(parser, varargin{:});

siz         = parser.Results.InputSize;
GoalFcn     = parser.Results.GoalFcn;
FeasibleFcn = parser.Results.FeasibleFcn;
n           = parser.Results.SwarmSize;
X           = parser.Results.InitialGuess;
iter        = parser.Results.Iteration;
phi         = parser.Results.PhiVector;

if(isempty(X))
    X = zeros(n,siz);
else
    if(row(X)==1)
        X = repmat(X,n,1);
    else
        if(row(X)~=n)
            error('Initial guess must be of shape [1 InputSize] or [SwarmSize InputSize].');
        end
    end
end

if(col(phi)==1)
    phi = repmat(phi,1,n);
else
    if(col(phi)~=n)
        error('Phi vector must be of shape [3 1] or [3 SwarmSize].');
    end
end
phi = phi./sum(phi,1);
r_p = clamp(rand(n,1),0.01,1);
r_g = clamp(rand(n,1),0.01,1);
phi = phi .* [ones(n,1); r_p; r_g];

V   = rand(n,siz);
X_p = X;
X_g = global_best(X,GoalFcn);

for i = 1 : iter
    V   = phi(1,:) .* V       + ...
          phi(2,:) .* (X_p-X) + ...
          phi(3,:) .* (X_g-X);
    X   = FeasibleFcn(X+V);
    X_p = particle_best(X,X_p,GoalFcn);
    X_g = global_best(X,GoalFcn); 
end
X = mean(X);
end

function [X_p] = particle_best(X,X_p,GoalFcn)
i = find(arrayfun(@(i) GoalFcn(X(i,:))<=GoalFcn(X_p(i,:)),(1:row(X))'));
X_p(i,:) = X(i,:);
end

function [X_g] = global_best(X,GoalFcn)
[~,i] = min(arrayfun(@(i) GoalFcn(X(i,:)),(1:row(X))'));
X_g = X(i,:);
end

