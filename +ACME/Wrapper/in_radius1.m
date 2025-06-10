function [J,D] = in_radius1(I,radius)
J = ((I-radius):(I+radius))';
D = abs(J-I);
end