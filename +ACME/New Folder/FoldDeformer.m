classdef FoldDeformer < AbstractDeformer
    properties
        Handle
    end
    
    methods
        function [obj] = FoldDeformer(varargin)
            obj@AbstractDeformer('Name','Fold',varargin{:});
            obj.Handle = 3;
        end
        
        function [P,N] = deform(obj,Pose)
            P = obj.Mesh.Vertex;
            N = obj.Mesh.Normal;
            W = obj.Skin.Weight;
            i = obj.Handle;
            j = setdiff(1:col(W),i);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Roughly true computation %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            wi = sum(W(:,i),2);
            wj = 1-wi;
            Ti = compute_transform(Pose(i,:),W(:,i))./wi;
            Tj = compute_transform(Pose(j,:),W(:,j))./wj;
            Ti(~isfinite(Ti)) = 0;
            Tj(~isfinite(Tj)) = 0;
            Ti = lin2mat(Ti);
            Tj = lin2mat(Tj);
            x = @(v) v(1:3)';
            for v = 1 : row(W)
                wiv = wi(v);
                wjv = wj(v);
                Tiv = Ti{v};
                Tjv = Tj{v};
                if((wiv*wjv)==0)
                    if(wiv~=0)
                        t = NaN(4,4);
                    else
                        t = NaN(4,4);
                    end
                else
                    t = (1/2) * (wiv * (Tiv/Tjv) + wjv * (Tjv/Tiv) + eye(4));
                end
                P(v,:) = x(t*[P(v,:) 1]');
                N(v,:) = x(t*[N(v,:) 0]');
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%
            % Cylinder Example Only %
            %%%%%%%%%%%%%%%%%%%%%%%%%
%             Pose = lin2mat(Pose);
%             t    = cellfun(@(m) m/Pose{1}   ,Pose,'UniformOutput',false);
%             tbar = cellfun(@(m) m/Pose{2},Pose,'UniformOutput',false);
%             pose = [{tbar{1}  + eye(4)};...
%                     {t{2}     + eye(4)};...%];
%                     {zeros(4) + eye(4)}];
%             pose = (0.5 * mat2lin(pose));
%             T    = compute_transform(pose,W);
%             P    = transform_point( T,P,'mat');
%             N    = transform_normal(T,N,'mat');
        end
    end
end