function [f] = function_distance( D0, Dt )
f = 1 - clamp( ( Dt + D0 ) ./ ( 2 * D0 ), 0, 1 );
f( ~isfinite(f) ) = 0;
f( D0 == 0 ) = 0;
end