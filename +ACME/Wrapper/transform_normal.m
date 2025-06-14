function [N] = transform_normal(T,N,type)
if(strcmpi(type,'mat'))
    N = [dotN(T(:,1: 3),N),...
         dotN(T(:,5: 7),N),...
         dotN(T(:,9:11),N)];
    return;
end
if(strcmpi(type,'dq'))
%     N = bsxfun(@plus,...
%                N,...
%                2 * cross( T(:,2:4),...
%                           bsxfun(@plus,cross(T(:,2:4),N,2), N .* T(:,1)),...
%                           2 )...
%               );

    N = N + 2 * ( ...
                  cross( T(:,2:4), cross(T(:,2:4),N,2) + N .* T(:,1), 2 ) ...
                );
    return;
end
end