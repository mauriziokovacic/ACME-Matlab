function [ K ] = Kronecker_delta( i, n )
K = sparse(i,1,1,n,1);
end