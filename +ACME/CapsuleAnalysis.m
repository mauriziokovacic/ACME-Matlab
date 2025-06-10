% clear all; clc;

% LoadData;

% L = cotangent_Laplacian(P,T) + 0.0001 * speye(size(P,1));
% id = fold_set(T,W);
% L(id,:) = e( id, size(P,1) );
% b = zeros(size(P));
% b(id,:) = P(id,:);
% P_ = L\b;
% b(id,:) = N(id,:);
% N_ = L\b;

% P_ = from_barycentric(P,tr,ID(E(:,2)),B(E(:,2),:));

% W_ = from_barycentric(W,T,ID(E(:,2)),B(E(:,2),:));
% W_ = closest_fold(W_);
% 
% N_ = from_barycentric(N,T,ID(E(:,2)),B(E(:,2),:));
% N_ = normr(P-P_);
% N_ = specular_direction(N_,normr(P_-P));
% tmp = cross( normr(N_), normr(P-P_), 2 );
% N_ = -normr( cross( N_, tmp, 2 ) );
% 
% [P_,N_]=compute_fittest(P_,N_,tr,10);



% F = [fold_field(W) fold_field(W,2) fold_field(W,3)];
N_ = normr(N_);

D = point_plane_distance(P_,N_,P);
A = dot(N_,N,2);

DD = D;
AA = A;
PP = P;
NN = N;

% LL = full(sum(diffusion_mass(P,T,W),2)).^(1/20);

% dW = W_ - W;




start_frame = 1;
n_frames    = 100;
compare     = false;
speed       = 1;
shots       = 1;
snapshot    = linspace( start_frame, n_frames+1,shots+1 );
record      = false;
rendering   = 'face';


px = [min(P(:,1)) max(P(:,1))];
py = [min(P(:,2)) max(P(:,2))];
pz = [min(P(:,3)) max(P(:,3))];
axis_lim = [px py pz];

h = figure;
x=[];
nn = numel(snapshot)-1;

if( (shots*~compare) > 1 )
    nn = nn+1;
%     h = [h;figure];
    x = [x;subplot(1,nn,1)];
    display_mesh(P,N,T);
    CreateAxes3D(x(end));
    setCameraPosition(P);
    axis equal;
    axis vis3d;
    axis(axis_lim);
end

if( record )
    set(h,'Units','Normalized');
    set(h,'OuterPosition',[0 0 1 1]);
    if( compare )
        vidObj = VideoWriter([path,'Comparison.mp4'],'MPEG-4');
    else
        vidObj = VideoWriter([path,'Animation.mp4'],'MPEG-4');
    end
    vidObj.Quality = 100;
    vidObj.open;
end




for iter = start_frame : speed : n_frames
    if( snapshot(1) <= iter )
%         h = [h;figure];
        if( compare )
            x = [];
        else
            x = [x;subplot(1,nn,numel(x)+1)];
        end
        snapshot = snapshot(2:end);
    end

if( compare )
    clf(h);
else
    gca = x(end);
    cla(x(end));
end
% axis equal;
% axis vis3d;

Pose = Anim{iter};

 

% Perform standard LBS
[PP, NN] = Linear_Blend_Skinning(P,N,W,Pose);

% LBS for the planes
[PP_, NN_] = Linear_Blend_Skinning(P_,N_,W_,Pose);

% Perform the CPS
DD = point_plane_distance( PP_, NN_, PP );
AA = dot( NN, NN_, 2 );
fD = function_distance( D, DD );
fA = function_angle( A, AA );
[alpha, beta] = function_deformation(fD,fA,I);

PPP = PP;
NNN = NN;

PPP = PPP + I .* alpha .* abs(DD-D) .* ((1-fA) .* NNN + fA .* -NN_);
NNN = NNN ...
    + I .* alpha .* abs(DD-D) .* ((fA).*beta(:,1).*NNN+(fD).*beta(:,1).*NN_) ...
    ;%- I .* fold_field(W,2) .* alpha .* abs(DD-D) .* NNN;
NNN = normr(NNN);

DD = point_plane_distance( PP_, NN_, PPP );
k = find( ( DD < 0 ) );
% k = setdiff(k,id);
PPP(k,:) = PPP(k,:)-DD(k,:).*NN_(k,:);
% NNN(k,:) = NNN(k,:)+(beta(k,2).*NNN(k,:)+(clamp(fD(k).*2,0,1)).*beta(k,1).*NN_(k,:));
NNN(k,:) = NNN(k,:)+(beta(k,1).*NNN(k,:)+(clamp(fD(k).*2,0,1)).*beta(k,1).*NN_(k,:));
NNN(k,:) = normr(NNN(k,:));


if( compare )
%     if( exist('c') )
%         c = c.setPosition(PP(1714,:)+25*NN(1714,:));
%         c = c.track(PP(1714,:));
%     end

    x=subplot(1,2,1);
    display_mesh(PP,NN,T,[],rendering,Material.Orange());
    title('LBS');
    CreateAxes3D(x(end));
%     if( exist('c') )
%         c.apply_to_axes(x(end),(iter-1)/(n_frames-1));
%     end
%     camlight(180,0);
%     camlight(0,0);
%     axis(axis_lim);
    camlight('right');
    camlight('headlight');
    
    
    
    x=[x;subplot(1,2,2)];
    display_mesh(PPP,NNN,T,[],rendering,Material.Blue());
    title('CPS');
    CreateAxes3D(x(end));
%     if( exist('c') )
%         c.apply_to_axes(x(end),(iter-1)/(n_frames-1));
%     end
%     camlight(180,0);
%      camlight(0,0);
%     axis(axis_lim);
    camlight('right');
    camlight('headlight');
    
    if( exist('c') )
        c.apply_to_axes(x,(iter-1)/(n_frames-1));
    end
    
    
%     x=[x;subplot(1,3,3)];
%     display_mesh(P,N,T,vecnorm3(PP-PPP));
%     title('CPS');
%     CreateAxes3D(x(end));
%     setCameraPosition(PP);
%     camlight(180,0);
%     camlight(0,0);
%     axis(axis_lim);
    
%     hold on;
%     plane3(P_(k,:),N_(k,:),[],5,[1 1 0]);
    
else
    
fig = display_mesh(PP,NN,T);
CreateAxes3D(x(end));
%         setCameraPosition(PP);
%     axis(axis_lim);
camlight('right');
camlight('headlight');
view(3);
if( exist('c') )
    c.apply_to_axes(x(end),(iter-1)/(n_frames-1));
end

% hold on;
% display_border(PPP,T,FS{1},'Color','r','LineWidth',3);
% hold on;
% plane3(PP_(13129,:),NN_(13129,:),[],5,[1 1 0]);

end
% set( x, 'Clipping','on');

if( record )
    for i = 1 : 16
        vidObj.writeVideo(getframe(gcf));
    end
end

% Pause before iterate again
pause( 0.08 );
end


if( record )
    for i = 1 : 60
        vidObj.writeVideo(getframe(gcf));
    end
vidObj.close();
end

rotate3d on;

if( numel(x)>1 )
    connect_axes(x);
end

