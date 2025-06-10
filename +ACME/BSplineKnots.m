function [knots, varargout] = BSplineKnots( ctrl, order )
n = size(ctrl,1)-1;
k = order;
knots = [ zeros((k)-1,1) ; linspace(0,1,(n-k+1) +(1+1) )' ; ones((k)-1,1)];
if( nargout > 1 )
    varargout{1} = [knots((k-1)+1), knots((n+1)+1)];
end
end