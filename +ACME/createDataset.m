function createDataset(n,type,path)
if(nargin<3)
    path = 'C:/Users/Maurizio/Devel/Matlab/Data/Dataset';
end
modelFcn = {@() Tetrahedron();@() Octahedron(); @() Cube(); @() Sphere(); @() Icosahedron()};
if(strcmpi(type,'sphere'))
    pNorm = 2;
end
if(strcmpi(type,'cube'))
    pNorm = Inf;
end
for i = 1 : n
    fun     = modelFcn{randperm(numel(modelFcn),1)};
    [P,~,T] = fun();
    T       = poly2tri(T);
    [P,T]   = soup2mesh(P,T);
    P       = rotatePoint(P);
    while(row(P)<400)
        [P,T]   = subdivide(P,T,1);
    end
    P       = P./vecnorm(P,pNorm,2);
    P       = rotatePoint(P);
    T       = poly2tri(T);
    [P,T]   = shuffleGeometry(P,T);
%     N       = vertex_normal(P,T);
    AbstractMesh('Vertex',P,'Face',T).save([path,'/',type,num2str(i),'.obj']);
end

end

function [P] = rotatePoint(P)
t       = randomTransform('r');
P       = (t*[P  ones(row(P),1)]')';
P       = P(:,1:3);
end