function [P,N,T] = buffer2mesh(Mask,Buffer)
% [~,T]   = mask2mesh(Mask);
% i       = find(logical(Mask));
% %Buffer  = permute(Buffer,[2,1,3]);
% Buffer  = reshape(Buffer,[],3);
% P       = face2vertex(Buffer(i,:),T);
% T       = quad2tri(T);
% [P,T]   = soup2mesh(P,T);
% N       = vertex_normal(P,T);



[x,y]   = meshgrid(linspace(0,1,col(Buffer)),linspace(0,1,row(Buffer)));
z = 1-Buffer;
%x = Buffer(:,:,1)'; y = Buffer(:,:,2)'; z = Buffer(:,:,3)';
[T,P] = surf2patch(x,y,z);
i = find(Mask);
T = T(prod(ismember(T,i),2)>0,:);
P = P(unique(T),:);
T = reindex(T);
T = quad2tri(T);
N = vertex_normal(P,T);
end