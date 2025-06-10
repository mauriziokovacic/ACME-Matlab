function border(P,T,W)
ID = skinning_regions(W);

I = ID(T(:,1));
J = ID(T(:,2));
K = ID(T(:,3));

ij = find( K~=I & I==J );
jk = find( I~=J & J==K );
ki = find( J~=K & K==I );

line3([P(T(ij,1),:) P(T(ij,2),:)], 'Color', 'red', 'LineWidth', 3 ); 
hold on;
line3([P(T(jk,2),:) P(T(jk,3),:)], 'Color', 'red', 'LineWidth', 3 ); 
hold on;
line3([P(T(ki,3),:) P(T(ki,1),:)], 'Color', 'red', 'LineWidth', 3 ); 

end