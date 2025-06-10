function BadWeightsExample()
[P,N,T,W,Anim] = LoadCapsuleData();

px = [min(P(:,1)) max(P(:,1))];
py = [min(P(:,2)) max(P(:,2))];
pz = [min(P(:,3)) max(P(:,3))];
axis_lim = [px py pz];

start_frame = 1;
n_frames    = 100;
speed       = 1;
record      = false;


f    = cell(3,1);
h    = figure;

x    = subplot(1,3,1);
f{1} = display_mesh(P,N,T);
CreateAxes3D( x(end) );
camlight('right');
axis(axis_lim);
title('Good Weights')
x(end).CameraPosition = [0 200 0];
x(end).CameraTarget = [0 0 0];

x    = [x;subplot(1,3,2)];
f{2} = display_mesh(P,N,T);
CreateAxes3D( x(end) );
camlight('right');
axis(axis_lim);
title('Good Weights')
x(end).CameraPosition = [0 200 0];
x(end).CameraTarget = [0 0 0];

x    = [x;subplot(1,3,3)];
f{3} = display_mesh(P,N,T);
CreateAxes3D( x(end) );
camlight('right');
axis(axis_lim);
title('Bad Weights')
x(end).CameraPosition = [0 200 0];
x(end).CameraTarget = [0 0 0];


prop = connect_axes(x);


if( record )
    set(h,'Units','Normalized');
    set(h,'OuterPosition',[0 0 1 1]);
    vidObj = VideoWriter(['Data/Cages','.mp4'],'MPEG-4');
    vidObj.Quality = 100;
    vidObj.open;
end

for i = 1 : 3
pause;
for iter = start_frame : speed : n_frames
Pose = Anim{i}{iter};

 

% Perform standard LBS
[PP,NN] = Linear_Blend_Skinning(P,N,W{i},Pose);


f{i}.Vertices      = PP;
f{i}.VertexNormals = NN;

if( record )
    vidObj.writeVideo(getframe(gcf));
    vidObj.writeVideo(getframe(gcf));
end

% Pause before iterate again
pause( 0.05 );
end
end

if( record )
    vidObj.close;
end

pause;
if( isvalid(h) )
    close(h);
end
end


function [PP,NN,TT,WW,AA] = LoadCapsuleData()
persistent P N T W Anim;
if( isempty(P) )
    B = cell(3,1);
    B{1} = 
    
    
    [P,N,~,T] = import_OBJ('Data/Capsule/Capsule');
    W = cell(3,1);
    W{1} = sparse([clamp((P(:,3)-0)/3+0.5,0,1), clamp(-(P(:,3)-0)/3+0.5,0,1)]);
    W{2} = sparse([clamp((P(:,3)+3)/3+0.5,0,1), clamp(-(P(:,3)+3)/3+0.5,0,1)]);
    W{1} = W{1} ./ sum(W{1},2);
    W{2} = W{2} ./ sum(W{2},2);
    W{3} = W{2};
    
    Anim = cell(3,1);
    Anim{1} = cellfun(@(i) [RotX(0);repmat(RotY((i-1)*pi/(110)),col(W{1})-1,1)],...
                            num2cell((1:100)'),...
                            'UniformOutput',false);
    extract = @(d) d(1:12);
    fun     = @(i) extract(Tra3([0 0 3],'matrix')'*RotY((i-1)*pi/(110),'matrix')'*Tra3([0 0 3],'matrix'));
    Anim{2} = cellfun(@(i) [RotX(0);repmat(fun(i),col(W{1})-1,1)],...
                            num2cell((1:100)'),...
                            'UniformOutput',false);
    Anim{3} = Anim{1};
end
PP = P;
NN = N;
TT = T;
WW = W;
AA = Anim;
end