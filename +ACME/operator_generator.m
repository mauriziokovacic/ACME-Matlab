function operator_generator(P,N,T,W,I,D,A,P_,N_,W_)
RotX = @(theta) [ 1 0 0 0 0 cos(theta) -sin(theta) 0 0 sin(theta) cos(theta) 0 ];
RotY = @(theta) [ cos(theta) 0 -sin(theta) 0 0 1 0 0 sin(theta) 0 cos(theta) 0 ];
RotZ = @(theta) [ cos(theta) -sin(theta) 0 0 sin(theta) cos(theta) 0 0 0 0 1 0 ];
Tra3 = @(trans) [ 1 0 0 trans(1) 0 1 0 trans(2) 0 0 1 trans(3) ];
Sca3 = @(scale) [ scale(1) 0 0 0 0 scale(2) 0 0 0 0 scale(3) 0 ];


h = figure;
for i = 1 : 100
    Anim{i} = repmat(RotX(0),size(W,2),1);
    Anim{i}(2:end,:) = repmat(RotY(-(i-1)*pi/(110)),size(W,2)-1,1);
end




t = timer('ExecutionMode','fixedSPacing','Period',0.1,'TimerFcn',@(obj,event) feedback_operator(h,P,N,T,W,I,D,A,P_,N_,W_,Anim) );
start(t);



end



function feedback_operator(h,P,N,T,W,I,D,A,P_,N_,W_,Anim)
persistent theta i step;
if( isempty(theta) )
    theta = 0;
end
if( isempty(i) )
    i = 1;
end
if( isempty(step) )
    step = 1;
end
if( i==1 )
    step = 1;
end
if( i == 100 )
    step = -1;
end

i = i + step;

clf(h);



Img = imread('Img/OP.png');
if( numel( size(Img) ) == 3 )
    Img = rgb2gray(Img);
end
Img = (double(Img) - (255*0.5)) / (255*0.5);

n = numel(Anim);
x = [];
% for i = 1 : n
    Pose = Anim{i};

    % Perform standard LBS
    M = compute_transform(Pose,W);
    [PP, NN] = apply_transform(P,N,M);
    NN = normr(NN);



    % LBS for the planes
    M_ = compute_transform(Pose,W_);
    [PP_, NN_] = apply_transform(P_,N_,M_);
    NN_ = normr(NN_);

    % Compute new angle
    AA = dot( NN, NN_, 2 );

    % Compute new distance
    DD = point_plane_distance( PP_, NN_, PP );


    % Perform the CPS
    fD = function_distance( D, DD );
    fA = function_angle( A, AA );
    
    X = linspace(0,1,size(Img,1));
    Y = linspace(0,1,size(Img,2));
    alpha = interp2(X,Y,Img,I,fD);
    

    PP = PP + I .* alpha .* abs(DD-D) .* ((1-fA) .* NN + fA .* -NN_);
    NN = normr((1-alpha).*NN + alpha .* abs(DD-D).* I .* -NN_);


    DD = point_plane_distance( PP_, NN_, PP );
    k = find( DD < 0 );
    PP(k,:) = PP(k,:)-DD(k,:).*NN_(k,:);
    NN(k,:) = normr(NN(k,:) + NN_(k,:));

    
%     x = [x;subplot(1,n,i)];
    display_mesh(PP,NN,T,[0.5 0.5 0.5]);
    axis([-5 5 -5 5 -5 5]);
    view(90,-180);
%     hold on;
% end
    theta = theta + 5;
end