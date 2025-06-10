function [PP,TT] = Loop_Subdivision(P,T,beta,iteration)
if(( nargin < 4 ) || isempty(iteration))
    iteration = 1;
end
if(( nargin < 3 ) || isempty(beta))
    beta = Loop_beta(3);
end

PP = P;
TT = T;
for n = 1 : iteration
    [I,J,K] = tri2ind(TT);
    Even = accumarray3([I;I;J;J;K;K],...
                       [beta*PP(J,:);beta*PP(K,:);...
                        beta*PP(K,:);beta*PP(I,:);...
                        beta*PP(I,:);beta*PP(J,:)]);
    k = accumarray([I;J;K],1);
    Even = Even + (1-k*beta) .* PP;
    
    % Extract edges and stuff
    [X,ix,ic] = unique(sort([I J; J K; K I],2),'rows');
    Odd  = accumarray3(X,(3/16) .* (PP(I,:)+PP(J,:)) + (1/8) .* PP(K,:));
    %%%%%%%%%%%%%%%%%%%%%%%%%
    
    PP = [Even;Odd];
    TT = X;
end
end

function [beta] = Loop_beta(n)
if( n < 3 )
    beta = 1/n * (5/8-(3/8+1/4*cos(2*pi/n))^2);
    return;
end
if( n == 3 )
    beta = 3/16;
    return;
end
beta = 3 / (8*n);
end