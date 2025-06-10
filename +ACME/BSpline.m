function [Q] = BSpline(P,T,k,t)
% Q = zeros(size(t,1),size(P,2));
% for i = 1 : size(P,1)
%     Q = Q + repmat(P(i,:),size(t,1),1) .* BSplineBasis(T,i,k+1,t);
% end
Q = BSplineCurve(P,k);
end

% function [N] = BSplineBasis(T,i,k,t)
% N = zeros(size(t,1),1);
% if( k == 1 )
%     N(find( ( t >= T(i) ) & ( t < T(i+1) ) )) = 1;
%     return;
% end
% alpha = (t - T(i)) ./ (T(i+k-1)-T(i));
% beta  = (T(i+k)-t) ./ (T(i+k)-T(i+1)); 
% alpha( ~isfinite(alpha) ) = 0;
% beta(  ~isfinite(beta ) ) = 0;
% N = alpha .* BSplineBasis(T,i,k-1,t) + ...
%     beta  .* BSplineBasis(T,i+1,k-1,t);
% end
