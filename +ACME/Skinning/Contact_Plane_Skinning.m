function [PP,NN] = Contact_Plane_Skinning(P,N,PP,NN,P_,N_,PP_,NN_,I,Op)
D  = point_plane_distance(P_,N_,P);
DD = point_plane_distance(PP_,NN_,PP);
fD = function_distance( D, DD );
A  = dot(N,N_,2);
AA = dot(NN,NN_,2);
fA = function_angle( A, AA );

[alpha, beta] = Op.fetch(fD,I);

PP = PP + alpha .* abs(DD-D) .* ( (1-fA)            .* NN + fA              .* -NN_ );
NN = NN + alpha .* abs(DD-D) .* ( (fA .* beta(:,1)) .* NN + fD .* beta(:,2) .*  NN_ );

DD = point_plane_distance( PP_, NN_, PP );
i  = find( ( DD < 0 ) & ( D > 0.001 ) );
PP(i,:) = PP(i,:) - DD(i,:) .* NN_(i,:);
NN(i,:) = NN(i,:) + ( beta(i,1) .* NN(i,:) + ( clamp(fD(i) .* 2, 0, 1) ) .* beta(i,2) .* NN_(i,:) );

NN = normr(NN);
end