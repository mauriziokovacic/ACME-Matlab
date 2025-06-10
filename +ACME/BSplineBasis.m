function [N] = BSplineBasis(knots,i,order,u)
k = order;
N = zeros(size(u,1),1);
if( k == 1 )
    N( find( ( knots((i)+1) <= u ) & ( u < knots((i+1)+1) ) ) ) = 1;
    return;
end
alpha = (u - knots((i)+1)) ./ (knots((i+k-1)+1)-knots((i)+1));
beta  = (knots((i+k)+1)-u) ./ (knots((i+k)+1)-knots((i+1)+1)); 
alpha( ~isfinite(alpha) ) = 0;
beta(  ~isfinite(beta ) ) = 0;
N = alpha .* BSplineBasis(knots,i,k-1,u) + ...
    beta  .* BSplineBasis(knots,i+1,k-1,u);
end