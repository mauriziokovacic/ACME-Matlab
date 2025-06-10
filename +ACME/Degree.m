function [ D ] = Degree( M )
D = spdiags(sum(M,2),0,size(M,1),size(M,2));
end