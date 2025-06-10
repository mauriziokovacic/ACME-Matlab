classdef ImplicitReconstruction < handle
    properties
        C
        W
        phi
    end
    
    methods
        function [obj] = ImplicitReconstruction(varargin)
            obj.C = [];
            obj.W = [];
            obj.phi = @(d) d.^3;
        end
        
        function [f] = F(obj,p)
            f = obj.W' * obj.phi(vecnorm3(obj.C-repmat(p,size(obj.C,1),1)));
        end
    end
    
    methods( Access = private )
        function [obj] = compute_centers(obj,N,eps)
            obj.C = [obj.C;obj.C+eps*N];
        end

        function [b] = compute_rhs(n,d)
            b = [zeros(n,1);d*ones(n,1)];
        end

        function [A] = compute_lhs(obj)
            n  = size(obj.C,1);
            Ci = repmat( obj.C,n,1);
            Cj = repelem(obj.C,n,1);
            A  = obj.phi(vecnorm3(Ci-Cj));
            A  = reshape(A,n,n);
        end

        function [obj] = compute_weight(obj,N,eps)
            b = obj.compute_rhs(size(obj.C,1),eps);
            obj = obj.compute_centers(N,eps);
            A = obj.compute_lhs(obj);
            obj.W = A\b;
        end

        
    end
end