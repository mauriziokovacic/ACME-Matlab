function [PP,NN] = apply_quaternion(P,N,Q)
    PP = P + 2 .* cross( Q(:,1:3), cross( Q(:,1:3), P, 2 ) +  Q(:,4) .* P, 2 );
    NN = N + 2 .* cross( Q(:,1:3), cross( Q(:,1:3), N, 2 ) +  Q(:,4) .* N, 2 );
end