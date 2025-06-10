function [ID] = bc(P,T,S)
ID = cell(row(S),1);
% [I,J,K] = tri2ind(T);
% for s = 1 : row(S)
%     A = from_barycentric(P,T,S{s}.T,S{s}.A);
%     B = from_barycentric(P,T,S{s}.T,S{s}.B);
%     j = unique(T(S{s}.T,:));
%     D = [point_segment_distance(A,B,P(I(S{s}.T),:)),...
%          point_segment_distance(A,B,P(J(S{s}.T),:)),...
%          point_segment_distance(A,B,P(K(S{s}.T),:))];
%     [~,i] = sort(D,2,'ascend');
%     i = [i(:,1);i(:,2)];
%     ID = [ID;T(sub2ind(size(T),[S{s}.T;S{s}.T],i))];
% end
for s = 1 : row(S)
    if(isempty(S{s}))
        continue;
    end
    [~,i] = sort(S{s}.A,2,'descend');
    [~,j] = sort(S{s}.B,2,'descend');
    i = i(:,1);
    j = j(:,1);
    t = repmat(S{s}.T,2,1);
    ID{s} = T(sub2ind(size(T),t,[i;j]));
end
end