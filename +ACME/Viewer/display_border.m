function [h] = display_border(P,T,ID,varargin)
if( col(ID) == 1 )
    [I,J,K] = tri2ind(T);
    tf = false(size(P,1),1);
    tf(ID) = true;
    E = [I J; J K; K I];
    E = unique(sort(E,2),'rows');
    i = find(tf(E(:,1))&tf(E(:,2)));
    j = E(i,2);
    i = E(i,1);
else
    i = ID(:,1);
    j = ID(:,2);
end
    h = line3( [P(i,:) P(j,:)], varargin{1:end} );
end