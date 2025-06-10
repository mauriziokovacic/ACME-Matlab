function ExampleCageSkeletonDeformation()
[M,C,Wm,Wc,MVC,Anim] = loadData();

CreateViewer3D('right');
hM = M.show();
hC = C.show();
for frame = 1 : numel(Anim)/2
    [p,n] = Linear_Blend_Skinning(M.Vertex,M.Normal,Wm,Anim{frame});
    [c,u] = Linear_Blend_Skinning(C.Vertex,C.Normal,Wc,Anim{frame});
    
    [a0,at] = areaFcn(C,c);
    d       = abs(at-a0)';
%     d(d>1)  = d(d>1)*2;
%     d(d<1)  = d(d<1)*0.5;
    
    w       = MVC .* d*0.5;
    p       = p + w * c;
    n       = vertex_normal(p,M.Face);
    
    hM.Vertices      = p;
    hM.VertexNormals = n;
    hC.Vertices      = c;
    hC.VertexNormals = u;
    drawnow;
end

end

function [M,C,Wm,Wc,MVC,Anim] = loadData()
M = AbstractMesh.LoadFromFile('Data/Capsule/Capsule.obj');
C = AbstractCage();
C.load('Data/Capsule/Cage2.obj');
C.recompute_normals();
Wm = [clamp(M.Vertex(:,3)/3+0.5,0,1), clamp(-M.Vertex(:,3)/3+0.5,0,1)].^2;
Wm = Wm./sum(Wm,2);
Wc = [clamp(C.Vertex(:,3)/3+0.5,0,1), clamp(-C.Vertex(:,3)/3+0.5,0,1)].^2;
Wc = Wc./sum(Wc,2);
% [MVC,~] = import_CAGE('Data/Capsule/MVC2');
% MVC = MVC./sum(MVC,2);
MVC = PinocchioWeights(M,C.Vertex);
Anim = cell(100,1);
for i = 1 : 100
    Anim{i} = repmat(RotX(0),2,1);
    Anim{i}(2:end,:) = repmat(RotX((i-1)*pi/(110)),1,1);
end
end

function [A0,At] = areaFcn(C,c)
A0 = triangle_area(C.Vertex,C.Face);
A0 = face2vertex(A0,C.Face);
At = triangle_area(c,C.Face);
At = face2vertex(At,C.Face);
end