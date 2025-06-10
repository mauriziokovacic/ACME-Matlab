classdef WeightDeformer < AbstractDeformer
    properties( Access = public, SetObservable )
        Point
        Normal
        Weight
        Value
        CoR
        Operator
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = WeightDeformer(varargin)
            obj@AbstractDeformer('Name','W',varargin{:});
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Point',  [], @(data) isnumeric(data));
            addParameter( parser, 'Normal', [], @(data) isnumeric(data));
            addParameter( parser, 'Weight', [], @(data) isnumeric(data));
            addParameter( parser, 'Value',  [], @(data) isnumeric(data));
            addParameter( parser, 'CoR',    [], @(data) isnumeric(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
    end
    
    methods( Access = public )
        function [P,N,P_,N_] = deform(obj,Pose)
            P  = obj.Mesh.Vertex;
            N  = obj.Mesh.Normal;
            C  = obj.CoR;
            P_ = obj.Point;
            N_ = obj.Normal;
            D  = normr(P-C);

            D0 = point_plane_distance(P_,N_,P);
            A0 = dotN(D,N_);

            [P ,N ,C] = CoRskin(obj,Pose);
            [P_,N_  ] = PlaneSkin(obj,Pose);
            D  = normr(P-C);

            Dt = point_plane_distance(P_,N_,P);
            At = dotN(D,N_);
            
            i      = find(Dt<0);
            P(i,:) = P(i,:) - obj.Value(i) .* Dt(i,:) .* N_(i,:);
            N(i,:) = (  obj.Value(i)) .*  N(i,:) +...
                     (1-obj.Value(i)) .* -N_(i,:);
            Dt(i) = 0;

            fD = function_distance(D0,Dt);
            fA = function_angle(A0,At);
            alpha = obj.Operator.fetch(fD,obj.Value);
            n  = abs(Dt-D0) .* ( (1-fA) .* D + fA .* -N_ );
            P  = P + (1-fA) .* alpha .* 1 .* n;
            N  = N + fA .* alpha .* ( n );%+ -N_);
            
            
        end
        
        function [P,N,C,T,Q] = CoRskin(obj,Pose)
            P = obj.Mesh.Vertex;
            N = obj.Mesh.Normal;
            C = obj.CoR;
            W = obj.Skin.Weight;
            T = compute_transform(Pose,W);
            Q = compute_dualquaternion(Pose,W);
            D = transform_normal(Q,P-C,'dq');
            C = transform_point(T,C,'mat');
            P = C+D;
            N = transform_normal(Q,N,'dq');
            N = normr(N);
        end
        
        function [P,N,T] = PlaneSkin(obj,Pose)
            P = obj.Point;
            N = obj.Normal;
            W = obj.Weight;
            T = compute_transform(Pose,W);
            P = transform_point(T,P,'mat');
            N = transform_normal(T,N,'mat');
            N = normr(N);
        end
        
        function [P,N,T] = SpecularSkin(obj,Pose)
            esoP = mat2lin(cellfun(@(t) inv(t), lin2mat(Pose),'UniformOutput',false));
            P = obj.Mesh.Vertex;
            N = obj.Mesh.Normal;
            W = specularWeight(obj);
            T = compute_transform(esoP,W);
            P = transform_point(T,P,'mat');
            N = transform_normal(T,N,'mat');
        end
        
    end
    
    methods
        function [dW] = dWeight(obj)
            dW = obj.Weight-obj.Skin.Weight;
        end
        
        function [W] = specularWeight(obj)
            W = obj.Weight+dWeight(obj);
            W = W ./ sum(W,2);
        end
        
        function computeData(obj)
            n  = nVertex(obj.Mesh);
            P  = obj.Mesh.Vertex;
            W  = obj.Skin.Weight;
            P_ = zeros(size(P));
            N_ = [ones(n,1) zeros(n,2)];
            N_ = reorient_plane(P_,N_,P);
            W_ = repmat(0.5,n,col(W));
            U_ = 1-normalize(abs(P(:,1)));
            obj.Point  = P_;
            obj.Normal = N_;
            obj.Weight = W_;
            obj.Value  = U_;
        end
    end
    
    methods( Static )
        function [Delta_d] = function_distance(D0,Dt)
            Delta_d = 1 - clamp( ( Dt + D0 ) ./ ( 2 * D0 ), 0, 1 );
            Delta_d( ~isfinite(Delta_d) ) = 0;
            Delta_d( D0 == 0 ) = 0;
        end
        
        function [Delta_theta] = function_angle(A0,At)
            c = 0.3;
            m = 0-c;
            M = 1+c;
            Delta_theta = 1-(clamp( (At+1) ./ (A0+1), m, M )-m)./(M-m);
            Delta_theta( ~isfinite(Delta_theta) ) = 0;
        end
    end
end