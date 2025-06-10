classdef SpecularDeformer < AbstractDeformer
    properties( Access = public, SetObservable )
        Point
        Normal
        Center
        Weight
        Value
        CoR
        Operator
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = SpecularDeformer(varargin)
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
        function [Pprime,Nprime,dD,X] = deform(obj,Pose)
            % Regular data
            P = obj.Mesh.Vertex;
            N = obj.Mesh.Normal;
            C = obj.CoR;
            W = obj.Skin.Weight;
            
            % Skin regular
            T      = compute_transform(Pose,W);
            q      = compute_dualquaternion(Pose,W);
            Cprime = transform_point(T,C,'mat');
            Pprime = Cprime + transform_normal(q,P-C,'dq');
            Nprime = normr(transform_normal(q,N,'dq'));
            
            % Plane data
            P_ = obj.Point;
            N_ = P-P_;%obj.Normal;
            W_ = obj.Weight;
            T  = compute_transform(Pose,W_);
            P_prime = transform_point(T,P_,'mat');
            N_prime = transform_normal(T,N_,'mat');
            D       = distance(P_,P);
            Dprime  = distance(P_prime,Pprime);
            dD = (D-Dprime);
            X = Pprime+N_prime;
            i = find(Dprime<D);
%             Pprime(i,:) = Pprime(i,:) + dD(i) .* (Pprime(i,:)-P_prime(i,:));
        end
        
        function [P,N,C] = CoRskin(obj,Pose)
            P = obj.Mesh.Vertex;
            C = obj.CoR;
            W = obj.Skin.Weight;
            T = compute_transform(Pose,W);
            Q = compute_dualquaternion(Pose,W);
            D = transform_normal(Q,P-C,'dq');
            C = transform_point(T,C,'mat');
            P = C+D;
            N = normr(transform_normal(Q,obj.Mesh.Normal,'dq'));
        end
        
        function [P,N] = PlaneSkin(obj,Pose)
            P = obj.Point;
            N = obj.Normal;
            W = obj.Weight;
            T = compute_transform(Pose,W);
            P = transform_point(T,P,'mat');
            N = transform_normal(T,N,'mat');
            N = normr(N);
        end
        
        function [P,X] = SpecularSkin(obj,Pose)
            P_ = obj.Point;
            P  = obj.Mesh.Vertex;
            C  = obj.CoR;
            X  = normr(P_-C);
            P  = C + specular_direction(X,P-C);
            W = specularWeight(obj);
            T = compute_transform(Pose,W);
            Q = compute_dualquaternion(Pose,W);
            D = transform_normal(Q,P-C,'dq');
            C = transform_point(T,C,'mat');
            P = C+D;
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