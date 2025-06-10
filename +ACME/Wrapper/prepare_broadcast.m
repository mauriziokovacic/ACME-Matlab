function [A,B] = prepare_broadcast(A,B,dim)
B = repelem(reshape(B,1,[],size(B,dim)),row(A),1,1);
A = reshape(A,[],1,size(A,dim));
end