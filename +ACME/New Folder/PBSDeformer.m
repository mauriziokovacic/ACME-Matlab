classdef PBSDeformer < AbstractDeformer
    methods( Access = public )
        function [obj] = PBSDeformer(varargin)
            obj@AbstractDeformer('Name','PBS',varargin{:});
        end
        
        function [P,N,varargout] = deform(obj,Pose)
            n = nVertex(obj.Mesh);
            m = nHandle(obj.Skin);
            [omega,i] = max(obj.Skin.Weight,[],2);
            
            W = obj.Skin.Weight;
            T = compute_transform(Pose,W);
            Q = compute_quaternion(Pose,W);
            
            t    = Pose(i,:);
            tbar = (T-t);
            
            poset    = Inv3(t).*     tbar;
            posetbar =      t .*Inv3(tbar);
            
            x = repmat(Eye3(),n,1);
            i = find(omega>0&omega<1);
            x(i,:) = 0.5*(   omega(i) .*poset(i,:)+...
                          (1-omega(i)).*posetbar(i,:) +...
                          repmat(Eye3(),numel(i),1));     
            
                      
            p = transform_point(x,obj.Mesh.Vertex,'mat');
            n = transform_normal(Q,Phi(omega).*(p-obj.Mesh.Vertex),'dq');
            
            P = transform_point(T,obj.Mesh.Vertex,'mat')+n;
            N = transform_normal(T,obj.Mesh.Normal,'mat');
            N = normr(N);
        end
    end
end