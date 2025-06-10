clear all; clc;


[P,N,~,T] = import_OBJ('Data/Capsule/Capsule');
% [C1,N1,~,T1] = import_OBJ('Data/Capsule/Cage1');
% [C2,N2,~,T2] = import_OBJ('Data/Capsule/Cage2');
% [MVC1,~] = import_CAGE('Data/Capsule/MVC1');
% [MVC2,~] = import_CAGE('Data/Capsule/MVC2');
% [GC1c,GC1f]  = import_CAGE('Data/Capsule/GC1');
% [GC2c,GC2f]  = import_CAGE('Data/Capsule/GC2');
% MVC1 = MVC1 ./ sum(MVC1,2);
% MVC2 = MVC2 ./ sum(MVC2,2);
% GC1c  = GC1c  ./ sum(GC1c,2);
% GC2c  = GC2c  ./ sum(GC2c,2);
% GC1f  = GC1f  ./ sum(GC1f,2);
% GC2f  = GC2f  ./ sum(GC2f,2);
P  = transform_point(repmat(RotZ(pi/4),size(P,1),1),P);
% C1 = transform_point(repmat(RotZ(pi/4),size(C1,1),1),C1);
% C2 = transform_point(repmat(RotZ(pi/4),size(C2,1),1),C2);
% N  = transform_normal(repmat(RotZ(pi/4),size(N,1),1),N);
% N1 = transform_normal(repmat(RotZ(pi/4),size(N1,1),1),N1);
% N2 = transform_normal(repmat(RotZ(pi/4),size(N2,1),1),N2);

W  = [clamp(P(:,3)/3+0.5,0,1), clamp(-P(:,3)/3+0.5,0,1)];
% W1 = [clamp(C1(:,3)/3+0.5,0,1), clamp(-C1(:,3)/3+0.5,0,1)];
% W2 = [clamp(C2(:,3)/3+0.5,0,1), clamp(-C2(:,3)/3+0.5,0,1)];









% F = fold_field(MVC2);

for i = 1 : 100
    Anim{i} = repmat(RotX(0),size(W,2),1);
    Anim{i}(2:end,:) = repmat(RotY((i-1)*pi/(110)),size(W,2)-1,1);
end

px = [min(P(:,1)) max(P(:,1))];
py = [min(P(:,2)) max(P(:,2))];
pz = [min(P(:,3)) max(P(:,3))];
axis_lim = [px py pz];

start_frame = 1;
n_frames    = 100;
compare     = false;
speed       = 1;
shots       = 1;
snapshot    = linspace( start_frame, n_frames+1,shots+1 );
record      = false;

h  = figure;
x  = [];
nn = numel(snapshot)-1;

if( (shots*~compare) > 1 )
    nn = nn+1;
%     h = [h;figure];
    x = [x;subplot(1,nn,1)];
    display_mesh(P,N,T,[0.5 0.5 0.5]);
    axis(axis_lim);
end

if( record )
set(h,'Units','Normalized');
set(h,'OuterPosition',[0 0 1 1]);
vidObj = VideoWriter(['Data/Cages','.mp4'],'MPEG-4');
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
axis equal;

Pose = Anim{iter};

 

% Perform standard LBS
M = compute_transform(Pose,W);
M1 = compute_transform(Pose,W1);
M2 = compute_transform(Pose,W2);

[PP,NN] = apply_transform(P,N,M);
NN = normr(NN);

[CC1, NN1] = apply_transform(C1,N1,M1);
NN1 = normr(NN1);

[CC2, NN2] = apply_transform(C2,N2,M2);
NN2 = normr(NN2);

S1      = Green_scale_factor(C1,T1,CC1);
S2      = Green_scale_factor(C2,T2,CC2);


[PP1,NN1] = MVC_deformation(T,MVC1,CC1);
[PP2,NN2] = MVC_deformation(T,MVC2,CC2);
% [PP,NN] = Green_deformation(T,CC1,T1,GC1c,GC1f,S1);
% [PP,NN] = Green_deformation(T,CC2,T2,GC2c,GC2f,S2);

if( true ) %compare )    
    x=subplot(1,3,1);
    display_mesh(PP,NN,T);%,nn);%[0.5 0.5 0.5]);
    CreateAxes3D(x(end));
    camlight('right');
    axis(axis_lim);
    title('Linear Blend Skinning')
    
    x=[x;subplot(1,3,2)];
    display_mesh(PP1,NN1,T);%,NNN);%[0.5 0.5 0.5]);
    CreateAxes3D(x(end));
    camlight('right');
    axis(axis_lim);
    title('MVC - Joint Slice')
    
    x=[x;subplot(1,3,3)];
    display_mesh(PP2,NN2,T);%,NNN);%[0.5 0.5 0.5]);
    CreateAxes3D(x(end));
    camlight('right');
    axis(axis_lim);
    title('MVC - No Joint Slice')
else
fig = display_mesh(PP,NN,T);%,F(:,1));%,[0.5 0.5 0.5]);%dd,[-1 1]);%[0.5 0.5 0.5]);
hold on;
display_cage(CC2,NN2,T2);
axis(axis_lim);
end

if( record )
vidObj.writeVideo(getframe(gcf));
vidObj.writeVideo(getframe(gcf));
end

% Pause before iterate again
pause( 0.05 );
end

if( record )
vidObj.close;
end

% if( numel(h)>1 )
% ax = get(h,'CurrentAxes');
% linkprop([ax{1:end}],...
if( numel(x)>1 )
linkprop(x,...
{'XDir',...
'YDir',...
'ZDir',...
'XScale',...
'YScale',...
'ZScale',...
'XLim',...
'YLim',...
'ZLim',...
'CameraPosition',...
'CameraPositionMode',...
'CameraTarget',...
'CameraTargetMode',...
'CameraUpVector',...
'CameraUpVectorMode',...
'CameraViewAngle',...
'CameraViewAngleMode',...
'View',...
'Clipping',...
'ClippingStyle'});

end



