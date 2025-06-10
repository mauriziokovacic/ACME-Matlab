function [theta] = signed_angle(A,B,N)
if(row(B)==1)
    B = repmat(B,row(A),1);
end
if(row(A)==1)
    A = repmat(A,row(B),1);
end
theta = angle(A,B) .* sign_of(dotN(N,cross(A,B,2)));
end