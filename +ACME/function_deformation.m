function [alpha, beta] = function_deformation( fD, ~, I )
persistent A Gx Gy;
if( isempty(A) )
    n  = 62;
    m  = ContactPlaneOperator(n,0);
    Gx = m.Beta;
    A  = m.Alpha;
%     A  = squeeze(m(:,:,1));
%     Gx = squeeze(m(:,:,2));
%     Gy = squeeze(m(:,:,3));

    [X,Y] = ndgrid(linspace(0,1,row(A)),linspace(0,1,col(A)));
    A  = griddedInterpolant(X,Y,A');
    Gx = griddedInterpolant(X,Y,Gx');
%     Gy = griddedInterpolant(X,Y,Gy');
end
% fD = fD/2;
alpha = A(I,fD);
beta  = Gx(I,fD);%normr([Gx(I,fD),Gy(I,fD)]);
end





% function [alpha, beta] = function_deformation( fD, fA, I )
% persistent A Gx Gy;
% persistent loadOP;
% 
% 
% if( isempty(loadOP) )
%     loadOP = false;
% %     n = 9;
% %      %N                                            F
% % A = [ 0     0     0     0    0     0    0     0    0;... % dt==d0
% %       0     0     0     0    0     0    0.1   0.4  0.9;...
% %       0     0     0.05  0.1  0.1   0.2  0.3   0.7  1.5;...
% %       0     0.05  0.1   0.2  0.1   0.1  0.2   0.6  0.9;...
% %       0.1   0.1   0.1   0.1  0.15  0.05 0.15  0    0;... % dt=0
% %       0.01  0.01  0.01  0.01 0.05 -0.1  0     0    0;...
% %      -0.1  -0.1  -0.1  -0.1  0     0    0     0    0;...
% %       0     0     0     0    0     0    0     0    0;...
% %       0     0     0     0    0     0    0     0    0];   % dt=-d0
%  
% 
%  
% % A = operator(); n = 512;
% % A = imresize(A,[512 512]); n = 512;
% Op = CPSOperator();
% % Op = Op.fromHeightFieldImage('Img/OP.png');
% % Op.Bulge = imgaussfilt(imgaussfilt(Op.Bulge,20),20);
% % Op = Op.computeGradient();
% n = 62;
% m = ContactPlaneOperator(n,1);
% % Op = Op.fromMatrix(m);
% 
% 
% % A  = Op.Bulge;
% % Gx = Op.Gx;
% % Gy = Op.Gy;
% 
% A  = fliplr(squeeze(m(:,:,1)));
% Gx = squeeze(m(:,:,2));
% Gy = squeeze(m(:,:,3));
% 
% % x  = repmat(256,1,2);
% % A  = imresize(A ,x);
% % Gx = imresize(Gx,x);
% % Gy = imresize(Gy,x);
% 
% % disp(['Max: ',num2str(max(max(A)))]);
% % disp(['Min: ',num2str(min(min(A)))]);
% clear Op n;
% [X,Y] = ndgrid(linspace(0,1,row(A)),linspace(0,1,col(A)));
% 
% A  = griddedInterpolant(X,Y,A');
% Gx = griddedInterpolant(X,Y,Gx');
% Gy = griddedInterpolant(X,Y,Gy');
% 
% end
% 
% alpha = A(I,fD/2);
% beta = normr([Gx(I,fD/2),Gy(I,fD/2)]);
% end