function [K] = rand_kernel(dim,nsamples)
K = zeros(dim);
K(randperm(numel(K),nsamples)) = 1;
end