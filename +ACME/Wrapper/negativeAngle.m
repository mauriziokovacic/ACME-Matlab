function [a] = negativeAngle(a)
a = mod(2*pi-equivalentAngle(a),2*pi);
end