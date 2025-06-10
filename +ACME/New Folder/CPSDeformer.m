classdef CPSDeformer < AbstractDeformer
    properties( Access = public, SetObservable )
        Contact
        Operator
        BaseDeformer
        Dir
    end

    methods( Access = public )
        function [obj] = CPSDeformer(varargin)
            obj@AbstractDeformer('Name','CPS',varargin{:});
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Contact',      [], @(data) isa(data,'AbstractContact'));
            addParameter( parser, 'Operator',     [], @(data) isa(data,'ContactPlaneOperator'));
            addParameter( parser, 'BaseDeformer', LBSDeformer('Mesh',obj.Mesh,'Skin',obj.Skin), @(data) isa(data,'AbstractDeformer'));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function [P,N,varargout] = deform(obj,Pose)
%             t = compute_quaternion(Pose,obj.Skin.Weight);
%             Dir = transform_normal(t,obj.Dir,'dq');
            
            [P , N ] = obj.BaseDeformer.deform(Pose);
            if(obj.RecomputeNormal)
                N = normr(obj.Mesh.adjacency('vf')*triangle_normal(P, obj.Mesh.Face));
            end

            [P_, N_] = obj.deform_planes(Pose);

            D0 = point_plane_distance( obj.Contact.Point,...
                                       obj.Contact.Normal,...
                                       obj.Mesh.Vertex );
            Dt = point_plane_distance( P_, N_, P );

            A0 = dotN( obj.Mesh.Normal, obj.Contact.Normal );
            At = dotN( N              , N_                 );

%             [P,N,Dt] = applyContactDeformation(obj,D0,Dt,A0,At,P,N,P_,N_);
%             [P,N]    = applyBulgeDeformation(obj,D0,Dt,A0,At,P,N,P_,N_);
% 
%             Dt = point_plane_distance( P_, N_, P );
%             [P,N,Dt] = applyContactDeformation(obj,D0,Dt,A0,At,P,N,P_,N_);
%             

            W  = obj.Skin.Weight;
            W_ = obj.Contact.Weight;
            U_ = obj.Contact.Value;
            w  = W + 2*(W_ - W);
            T  = lin2mat(compute_transform(Pose,W));
            T_ = lin2mat(compute_transform(Pose,w));
            
            fA      = CPSDeformer.function_angle( A0, At );
            fD      = CPSDeformer.function_distance( D0, Dt );
            [alpha] = obj.Operator.fetch(fD,U_);
            
            T_ = (1-fA.* alpha) .* repmat(Eye3(), row(P),1) + ...
                 (0+fA.* alpha) .* mat2lin(cellfun(@(a,b) a*b',T,T_,'UniformOutput',false));
            P = transform_point(T_,P,'mat') + fD.*alpha.*P;
            
            
            N = normr(N);

            if(nargout>=3)
                varargout{1} = P_;
            end
            if(nargout>=4)
                varargout{2} = N_;
            end
            if(nargout>=5)
                varargout{3} = 0;%fD;
            end
            if(nargout>=6)
                varargout{4} = D0;
            end
            if(nargout>=7)
                varargout{5} = Dt;
            end
            if(nargout>=8)
                varargout{6} = 0;%fA;
            end
            if(nargout>=9)
                varargout{7} = A0;
            end
            if(nargout>=10)
                varargout{8} = At;
            end
        end
        
        function [P_,N_] = deform_planes(obj,Pose)
            [P_, N_] = Linear_Blend_Skinning(...
                            obj.Contact.Point,...
                            obj.Contact.Normal,...
                            obj.Contact.Weight,...
                            Pose);
        end
        
        function [P,N,Dt] = applyContactDeformation(obj,D0,Dt,A0,At,P,N,P_,N_)
            i      = find((Dt<0)&(D0>0.001)&(obj.Contact.Value>0));
            P(i,:) = P(i,:) - Dt(i,:) .* N_(i,:);
            N(i,:) = (  obj.Contact.Value(i)) .*  N(i,:) +...
                     (1-obj.Contact.Value(i)) .* -N_(i,:);
            Dt(i)  = 0;
        end
        
        function [P,N] = applyBulgeDeformation(obj,D0,Dt,A0,At,P,N,P_,N_)
            fA      = CPSDeformer.function_angle( A0, At );
            fD      = CPSDeformer.function_distance( D0, Dt );
            [alpha] = obj.Operator.fetch(fD,obj.Contact.Value);
            x = logical(Dt>0);
            x = 1;
            n       = x .* abs(Dt-D0) .* ( (1-fA) .* N + fA .* -N_);%normr(P-C) );
            P       = P + 1  .* alpha .* n;
            N       = N + fA .* alpha .* ( n + -N_);
        end
        
        function [name] = getName(obj)
            name = [obj.Name,'-',obj.Operator.Name];
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