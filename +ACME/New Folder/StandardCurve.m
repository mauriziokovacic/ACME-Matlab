classdef StandardCurve < AbstractCurve
    methods( Access = public, Sealed = true )
        function [obj] = StandardCurve(varargin)
            obj@AbstractCurve(varargin{:});
        end
        
        function [C] = resampled(obj,n)
            C = [];
            if(numel(n)==1)
                n = repmat(n,numel(obj),1);
            end
            for i = 1 : numel(obj)
                c  = obj(i);
                nn = n(i);
                t  = parameter(c);
                P  = getPoint(c);
                T  = tangent(c);
                N  = normal(c);
                B  = bitangent(c);

                P = [P(c.Edge(:,1),:);P(c.Edge(end,2),:)];
                T = [T(c.Edge(:,1),:);T(c.Edge(end,2),:)];
                N = [N(c.Edge(:,1),:);N(c.Edge(end,2),:)];
                B = [B(c.Edge(:,1),:);B(c.Edge(end,2),:)];

                q = linspace(0,1,nn);
                P = interp1(t,P,q,'pchip');
                T = interp1(t,T,q,'pchip');
                N = interp1(t,N,q,'pchip');
                B = interp1(t,B,q,'pchip');
                E = [(1:nn-1)' (2:nn)'];

                C = [C;StandardCurve('Point',P,...
                                     'Edge',E,...
                                     'Name',c.Name,...
                                     'Tangent',T,...
                                     'Normal',N,...
                                     'Bitangent',B)];
            end
        end
        
        function [C] = uniform(obj)
            n = floor(arrayfun(@(c) row(c.Point),obj));
            C = obj.resampled(n);
        end
    end
    
    methods( Access = public )
        function computeTangent(obj)
            f = @(e,d) normr(accumarray3([e(:,1);e(:,2)],[d;d],[row(obj.Point),3]));
            P = getPoint(obj);
            obj.Tangent = f(obj.Edge,P(obj.Edge(:,2),:)-P(obj.Edge(:,1),:));
        end
        
        function computeNormal(obj)
            f = @(e,d) normr(accumarray3([e(:,1);e(:,2)],[d;d],[row(obj.Point),3]));
            T = tangent(obj);
            obj.Normal = f(obj.Edge,T(obj.Edge(:,2),:)-T(obj.Edge(:,1),:));
        end
        
        function computeBitangent(obj)
            T = obj.Tangent;
            N = obj.Normal;
            obj.Bitangent = normr(cross(T,N,2));
        end
    end
end