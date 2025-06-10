% function [E] = computeContactPlane(Mesh,Skin,Skel)
% P     = Mesh.Vertex;
% T     = Mesh.Face;
% [P,T] = subdivide(P,T,2);
% M     = AbstractMesh('Vertex',P,'Face',T);
% 
% 
% end


function [E] = computeContactPlane(M,Skin,Skel)
Pj = referenceJointPosition(Skel);
Nj = referenceJointOrientation(Skel);
P  = M.Vertex;
Q  = P;
T  = M.Face;

W  = Skin.Weight;
E  = cell(nVertex(M),nJoint(Skel));
for j = 1 : nJoint(Skel)
    if(isRoot(Skel,j)||isLeaf(Skel,j))
        continue;
    end
    n = repmat(Nj(j,:),row(P),1);
    U = P-Pj(j,:);
    D = vecnorm(U,2,2);
    R = normr(cross(n,U,2));
    s = normr(cross(n,R,2));
    S = specular_direction(s,U);
    for i = 1 : row(P)
%         ed = EnergyDistance(D(i),D);
%         er = EnergyRotation(Pj(j,:),R(i,:),P);
%         es = EnergySpecular(normr(S(i,:)),normr(U));
%         e  = ed + er + es;
%         k  = min_index(e);
%         E{i,j} = [e(k),k];
        TT = T;
        d  = point_plane_distance(Pj(j,:),R(i,:),P);
        t  = sum(d(TT)<0,2);
        t  = find((t==1)|(t==2));
        TT = TT(t,:);
        k  = unique(TT)';
        p  = project_point_on_plane(Pj(j,:),R(i,:),P(k,:));
        FoldCurve
        d  = abs(D(i)-distance(p,Pj(j,:)));
        k  = find(d<0.001);
        p = p(k,:);
        x  = signed_angle(p-Pj(j,:),repmat(U(i,:),row(p),1),R(i,:));
        k  = find(x<=0);
        k  = k(min_index(x(k)));
        if(isempty(k))
            k = P(i,:);
        else
            k = p(k,:);
        end
        E{i,j} = [k];
    end
end

% Step 1: take all the triangles for which at least a point is reachable
% Step 2: take all the triangles crossed by the plane
% Step 3: ?
% Step 4: profit


end


function [E] = EnergyDistance(Di,Dk) % Di and Dk are the point-joint distance
E = abs(Di-Dk).^2;
end

function [E] = EnergyRotation(Pj,Ri,Pk) % Pj is the joint position, Ri = NjxUi normalized
E = abs(point_plane_distance(Pj,Ri,Pk)).^2;
end

function [E] = EnergySpecular(Si,Uk) % Assume Si and Uk normalized
E = (angle(Si,Uk)).^2;
end