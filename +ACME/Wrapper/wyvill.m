function [F] = wyvill(D)
D2 = D.^2;
D4 = D2.^2;
D6 = D2.*D4;
F  = 1-clamp((9 - ( 4 .* D6 ) + ( 17 .* D4 )- ( 22 .* D2 ) ) ./ 9,0,1);
end