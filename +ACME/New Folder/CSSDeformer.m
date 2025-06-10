classdef CSSDeformer < AbstractDeformer
    properties( Access = public, SetObservable )
        Operator
        C
        W
        r
        C_
        W_
        r_
        U
    end

    methods( Access = public )
        function [obj] = CSSDeformer(varargin)
            obj@AbstractDeformer('Name','CSS',varargin{:});
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Operator', ContactPlaneOperator.Bulge(256,1), @(data) isa(data,'ContactPlaneOperator'));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
            P      = obj.Mesh.Vertex;
            obj.C  = P .* [1 0 0];
            obj.W  = obj.Skin.Weight;
            obj.r  = ones(row(P),1);
            obj.C_ = -obj.C;
            obj.W_ = obj.W(:,[2 1 3]);
            obj.r_ = obj.r;
            obj.U  = normalize((vecnorm3(obj.C-P)-obj.r)-(vecnorm3(obj.C_-P)-obj.r_));
        end
        
        function [Pprime,Nprime,varargout] = deform(obj,Pose)
            P  = obj.Mesh.Vertex;
            N  = obj.Mesh.Normal;
            C  = obj.C;
            C_ = obj.C_;
            D  = C -P;
            D_ = C_-P;
            P_ = 0.5.*(C+C_);
            N_ = normr(D-D_);

            [Pprime,Nprime,Cprime] = Center_Of_Rotation(P,N,obj.Skin.Weight,Pose,C);
%             [Pprime , Nprime] = Dual_Quaternion_Skinning(P,N,obj.Skin.Weight,Pose);
%             Cprime  = Dual_Quaternion_Skinning(C ,zeros(size(C )),obj.W ,Pose);
            C_prime = Dual_Quaternion_Skinning(C_,zeros(size(C_)),obj.W_,Pose);
            Dprime  = Cprime -Pprime;
            D_prime = C_prime-Pprime;
            P_prime = 0.5.*(Cprime+C_prime);
            N_prime = normr(Dprime-D_prime);

            D0 = point_plane_distance(P_,N_,P);
            Dt = point_plane_distance(P_prime,N_prime,Pprime);
            
            A0 = dotN( D,      D_      );
            At = dotN( Dprime, D_prime );

%             [Pprime,Nprime,Dt] = applyContactDeformation(obj,D0,Dt,Pprime,Nprime,N_prime);
            [Pprime,Nprime]    = applyBulgeDeformation(obj,D0,Dt,A0,At,Pprime,Nprime,Dprime,P_prime,N_prime);

            Dt = point_plane_distance(P_prime,N_prime,Pprime);
            [Pprime,Nprime,Dt] = applyContactDeformation(obj,D0,Dt,Pprime,Nprime,N_prime);
            
            Nprime = normr(Nprime);
        end
        
        
        function [P,N,Dt] = applyContactDeformation(obj,D0,Dt,P,N,N_)
            i      = find((Dt<0)&(D0>0.001));%&(obj.U>0));
            P(i,:) = P(i,:) - (obj.U(i)>0) .* Dt(i,:) .* N_(i,:);
            N(i,:) = ( obj.U(i)) .* N(i,:) + (1-obj.U(i)) .* -N_(i,:);
            Dt(i)  = (obj.U(i)>0) .* 0 + ~(obj.U(i)>0) .* Dt(i);
        end
        
        function [P,N] = applyBulgeDeformation(obj,D0,Dt,A0,At,P,N,D,P_,N_)
            fA      = CSSDeformer.function_angle( A0, At );
            fD      = CSSDeformer.function_distance( D0, Dt );
            [alpha] = obj.Operator.fetch(fD,obj.U);
            n       = abs(Dt-D0) .* ( (1-fA) .* normr(D) + fA .* -N_);%normr(P-C) );
            P       = P + alpha .* n;
            N       = N + fA .* alpha .* ( n + -N_);
        end
        
        function [name] = getName(obj)
            name = 'CSS';
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




function [] = xxx(Mesh,Skin,FC,Skel)
P = Mesh.Vertex;
W = Skin.Weight;

[C,i] = project_on_bone(Skel,P);
C     = cell2mat(arrayfun(@(k) W(k,i)*C{k},(1:row(P))','UniformOutput',false));
r     = vecnorm3(P-C);
KDT   = KDTreeSearcher(C);

for k = 1 : numel(FC)
    h = FC(k).Handle;
    p = surfacePoint(FC(k));
    w = surfaceWeight(FC(k));
    c = surfaceData(FC(k),C);
    d = normr(p-c);
    x = mean(c);
    
    i  = find(W(:,h)>=0.5);
    
    dw = cell2mat(arrayfun(@(v) mean(w-W(v,:)),i,'UniformOutput',false));
    dW = abs(W(i,:)-2*dw);
    dW = dW ./ sum(dW,2);
    dX = cell2mat(arrayfun(@(v) mean(x+specular_direction(d,P(v,:)-x)),i,'UniformOutput',false));
    [dX,j] = project_on_bone(Skel,dX);
    dX     = cell2mat(arrayfun(@(k) dW(k,j)*dX{k},(1:row(dX))','UniformOutput',false));
    j  = knnsearch(KDT,dX,'K',1);
    C_ = dX;
    r_ = r(j);
end


end


