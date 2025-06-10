clc; clear all;

name = 'Hand';
path = ['Data/',name,'/'];

switch lower(name)
    case 'triangle'
        P          = [1 1 0; 0 1 0; 0 0 0];
        N          = repmat([1 0 0],3,1);
        UV         = zeros(3,2);
        T          = [1 2 3];
        W          = [0 1; 1 0; 1 0];
        ModelPose  = lin2mat([Tra3([1 0.5 0]);Tra3([0.5 0.5 0]);Tra3([0 0.5 0])]);
        G          = skeletonGraph(sparse([1,2],[2,3],1,3,3));
        Skel       = BaseSkeleton.createFromSkeletonPose(G,ModelPose);
    case 'grid'
        [P,N,T,UV] = Plane(1,[10 10]);
        P = P(:,[1 3 2]);
        T          = quad2tri(T);
        W          = P(:,1)+0.5;
        W          = interp1(linspace(0,1,11),fliplr([1 1 1 0.75 0.625 0.5 0.425 0.25 0 0 0]),P(:,1)+0.5);
        W          = sparse([W 1-W]);
        ModelPose  = lin2mat([Tra3([0.5 0 0]);Tra3([0 0 0]);Tra3([-0.5 0 0])]);
        G          = skeletonGraph(sparse([1,2],[2,3],1,3,3));
        Skel       = BaseSkeleton.createFromSkeletonPose(G,ModelPose);
    case 'cylinder'
        [P,N,T,UV] = Cylinder(10,1,[64,48]);
        %T          = quad2tri(T);
        P(:,3)     = P(:,3) - max(P(:,3))/2;
        P          = (axang2rotm([0 1 0 pi/2])*P')';
        N          = (axang2rotm([0 1 0 pi/2])*N')';
        t          = 0.35;
        [P,T,I]    = soup2mesh(P,T);
        N          = N(I,:);
        UV         = UV(I,:);
        W          = normalize(clamp(normalize(P(:,1)),t,1-t));
        W          = [W 1-W];
        W          = (W./sum(W,2)).^ceil(0.5/t);
        W          = sparse(W./sum(W,2));
        ModelPose  = lin2mat([Tra3([5 0 0]);Tra3([0 0 0]);Tra3([-5 0 0])]);
        G          = skeletonGraph(sparse([1,2],[2,3],1,3,3));
        Skel       = BaseSkeleton.createFromSkeletonPose(G,ModelPose);
        clear t;
    case 'snake'
        [P,N,UV,T] = import_OBJ( [path,'Snake'] );
        T          = quad2tri(T);
        [P,T,I]    = soup2mesh(P,T);
        N          = vertex_normal(P,T);
        [ W      ] = import_WGT( [path,'Skin'] );
        W(:,end)   = 0;
        W          = W./sum(W,2);
        W          = W(I,:);
        ModelPose  = lin2mat([Tra3([12.5-5*0 0 0]);...
                              Tra3([12.5-5*1 0 0]);...
                              Tra3([12.5-5*2 0 0]);...
                              Tra3([12.5-5*3 0 0]);...
                              Tra3([12.5-5*4 0 0]);...
                              Tra3([12.5-5*5 0 0])]);
        G          = skeletonGraph(sparse([1,2,3,4,5],[2,3,4,5,6],1,6,6));
        Skel       = BaseSkeleton.createFromSkeletonPose(G,ModelPose);
    otherwise
        [P,UV,~,T] = import_GEO( [path,'Geometry'] );
        N = vertex_normal(P,T);
        [ W           ] = import_SKN( [path,'Skin'] );
        [Sname,~,Schild,~,~,~,~,ModelPose] = import_SKEL([path,'Skeleton']);
        ModelPose = lin2mat(ModelPose);
        G         = skeletonGraph(Schild,'NodeName',Sname);
        Skel      = BaseSkeleton.createFromSkeletonPose(G,ModelPose);
end

% [ W, F, FS, FD ]        = import_SKN( [path,'Skin'] );
% [ U, gU, dU ]           = import_FLD( [path,'Geodesic'] );
% [ ID, B, E, Dir ]       = import_PTH( [path,'Path'] );
% [ P_, N_, W_, D, A, I ] = import_CNT( [path,'Contact'] );

W         = [W,sparse(row(P),nJoint(Skel)-col(W))];
% Sp = Sp(1:col(W),:);
% Sd = Sd(1:col(W),:);
% if( size(W,2) < size(Sd,1) )
%     Flow = W * Sd(1:end-1,:);
% else
%     Flow = W * Sd;
% end
% 
% id = unique([FS{1}(:,1);FS{1}(:,2)]);

if( strcmpi(name,'Snake') )
    Anim = cell(2,1);
    Anim{1} = mat2lin(Skel.relativePose());
    Skel.assignPosefromDelta([zeros(6,3),...
                              [0 0 0;...
                              0 -pi 0;...
                              0 0 pi;...
                              0 pi 0;...
                              0 pi 0;...
                              0 0 0]/2]);
    Anim{2} = mat2lin(Skel.relativePose());
    Skel.discardDelta();
else
    if( ( exist( [path,'Animation.anim'],'file' ) == 2 ) && ~strcmpi(name,'Cylinder') )
        Anim = import_ANIM( [path,'Animation'] );
        for i = 1 : numel(Anim)
            if(row(Anim{i})<col(W))
                Anim{i} = [Anim{i};repmat(Eye3('linear'),col(W)-row(Anim{i}),1)];
            end
        end
    else
        Anim = cell(100,1);
        for i = 1 : 100
            Anim{i} = [RotX(0);...
                       repmat(...
                              mat2lin(RotZ(-(i-1)*pi/(100),'matrix')),...
                              col(W)-1,1)];
        end
        Anim(101:200) = flipud(Anim(1:100));
    %     for i = 201 : 300
    %         Anim{i} = [RotX(0);...
    %                    repmat(...
    %                           mat2lin(RotZ(-(i-1)*pi/(100),'matrix')*...
    %                                   RotY(pi/16,'matrix')*...
    %                                   RotX(-(i-1)*pi/(200),'matrix')*...
    %                                   Eye3('matrix')),...
    %                           col(W)-1,1)];
    %     end
    end
end
Anim = cellfun(@(Pose) Pose(1:col(W),:),Anim,'UniformOutput',false')';
% Anim = Anim';

if( strcmpi(name,'Cylinder' ) )
    v = find(abs(P(:,1))>1.6);
    [~,b] = sort(W,2,'descend');
    b = b(v,2:end);
    for i = 1 : numel(v)
        for j = 1 : size(b,2)
            W(v(i),b(i,j)) = 0;
        end
    end
    W = W ./ sum(W,2);
    clear v b i j;
end

if( strcmpi(name,'Triangle' ) )
    for i = 1 : 100
        Anim{i} = repmat(RotX(0),col(W),1);
        Anim{i}(1,:) = RotY(-(i-1)*pi/(110));
    end
end

if( strcmpi(name,'Beast') || strcmpi(name,'Boy') )
    W(:,[5,9,17,22,25]) = 0;
    W = W./sum(W,2);
end

if( strcmpi(name,'Animal') )
    W(:,[5,9,17,22,24,31]) = 0;
    W = W./sum(W,2);
end

% if( strcmpi(name,'Woman') )
%     w = [44779;44806;44780;44582];
%     for i = 1 : numel(w)
%         W(w(i),2:end) = W(w(i),2:end)/(1-W(w(i),1));
%         W(w(i),2:end) = W(w(i),2:end) * 0.49;
%         W(w(i),1) = 0.51;
%     end
% end

% if( strcmp( name, 'Cylinder' ) )
% P_ = zeros(size(P));
% N_ = repmat([1 0 0], size(P,1),1);
% D  = point_plane_distance(P_,N_,P);
% id = find( D < 0 );
% N_(id,:) = -N_(id,:);
% D  = point_plane_distance(P_,N_,P);
% A = dot(N,N_,2);
% end


Op = ContactPlaneOperator.HardWrinkle(256,1)+ContactPlaneOperator.Bulge(256,1);

M  = AbstractMesh('Vertex',P,'Normal',N,'UV',UV,'Face',T);
S  = AbstractSkin('Mesh',M,'Weight',W);
% % if(~strcmpi(name,'Cylinder'))
%     tic
%     FC = FoldCurve.createFromSkin(M,S,'soft');
%     toc
% % end
% if( strcmpi(name,'Cylinder') )
%     X = AbstractContact('Mesh',M,...
%                         'Skin',   S,...
%                         'Point',  project_point_on_plane([0 0 0],[1 0 0],P),...
%                         'Normal', reorient_plane(zeros(size(P)),repmat([1 0 0],row(P),1),P),...
%                         'Weight', [repmat(0.5,row(P),2) sparse(row(P),col(W)-2)],...
%                         'Value',  1-normalize(abs(P(:,1)),0,6),...
%                         'Name',   'Cylinder');
% else
%     X  = AbstractContact('Mesh',M,'Skin',S);
%     tic
%     computeContact(X,FC);
%     toc
% end
% 
LBS = LBSDeformer('Mesh',M,'Skin',S);
DQS = DQSDeformer('Mesh',M,'Skin',S);
% if(isfile([path,'CoR.cor'])&&~strcmpi(name,'Cylinder'))
%     c = import_COR([path,'CoR']);
% else
%     [x,i] = project_on_bone(Skel,P);
%     c = cell2mat(arrayfun(@(k) W(k,i)*x{k},(1:row(P))','UniformOutput',false));
% end
% COR = CORDeformer('Mesh',M,'Skin',S,'CoR',c);
% CPS = CPSDeformer('Mesh',M,'Skin',S,'Contact',X,'Operator',Op);
% [x,i] = project_on_bone(Skel,P);
% xx = cell2mat(arrayfun(@(k) W(k,i)*x{k},(1:row(P))','UniformOutput',false));
% CPS.Dir = normr(0.7*normr(P-xx)+0.3*N);
% CPS.BaseDeformer = COR;


F  = fold_skeleton_weight(Skel,W);
% FC = FoldCurve.createFromData(P,N,T,F);