classdef FoldCurve < SurfaceCurve
    properties( Access = public, SetObservable )
        Skin % Skin handle
        Handle
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = FoldCurve(varargin)
            obj@SurfaceCurve(varargin{:});
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Skin',   [], @(data) isa(data,'AbstractSkin'));
            addParameter( parser, 'Handle', [], @(data) isscalar(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function [W] = surfaceWeight(obj,i)
            if((nargin<2)||isempty(i))
                i = (1:row(obj.Point))';
            end
            W = surfaceData(obj,obj.Skin.Weight,i);
        end
        
        function [W] = getWeight(obj,i)
            if((nargin<2)||isempty(i))
                i = (1:row(obj.Point))';
            end
            W = surfaceWeight(obj,i);
        end
        
        function [h] = getHandle(obj)
            h = obj.Handle;
        end
        
        function [P_,N_] = curve_planes(obj,CoR)
            P_ = [];
            N_ = [];
            for n = 1 : numel(obj)
                Curve = obj(n);
                P     = getPoint(Curve);
                E     = Curve.Edge;
                [I,J] = edge2ind(E);
                C     = surfaceData(Curve,CoR);
                
                Pi = P(I,:);
                Pj = P(J,:);
                C  = 0.5*(C(I,:)+C(J,:));
                
                Ei = Pi-C;
                Ej = Pj-C;

                p_ = 0.5*(Pi+Pj);
                n_ = normr(cross(Ei,Ej,2));
                
                for i = 1 : col(n_)
                    n_(:,i) = smooth(n_(:,i),0.1,'rloess');
                end
                
                P_ = [P_;{p_}];
                N_ = [N_;{n_}];
            end
        end
    end
    
    methods( Access = public )
        function computeNormal(obj)
            for n = 1 : numel(obj)
                c = obj(n);
                P = surfacePoint(c);
                N = surfaceNormal(c);
                C = mean(P);
                r = distance(P,C);
                T = tangent(c);
                c.Normal = zeros(size(P));
                for i = 1 : row(P)
                    v = c.Mesh.rnn(P(i,:),r(i));
                    U = c.Mesh.Normal(v,:);
                    U = U(dotN(U,N(i,:))>0,:);
                    c.Normal(i,:) = normr(mean(U));
                end
                c.Normal = cross(T,c.Normal,2);
            end
        end

    end
    
    methods( Static )
        function [C,M,S] = createFromData(P,N,T,W,type)
            if(nargin<5)
                type = 'soft';
            end
            M = AbstractMesh('Vertex',P,'Normal',N,'Face',T);
            [C,S] = FoldCurve.createFromWeights(M,W,type);
        end
        
        function [C,S] = createFromWeights(MeshHandle,W,type)
            if(nargin<3)
                type = 'soft';
            end
            S = AbstractSkin('Mesh',MeshHandle,'Weight',W);
            C = FoldCurve.createFromSkin(MeshHandle,S,type);
        end
        
        function [C] = createFromSkin(MeshHandle,SkinHandle,type)
            C = [];
            if(nargin<3)
                type = 'soft';
            end
            if(isscalar(type))
                S = createCurveFromField(MeshHandle,SkinHandle.Weight,type);
            else
                if(strcmpi(type,'soft'))
                    S = createCurveFromField(MeshHandle,SkinHandle.Weight,0.5);
                end
                if(strcmpi(type,'hard'))
                    S = createCurveFromField(MeshHandle,Gamma(SkinHandle.Weight),0);
                end
            end
            for i = 1 : row(S)
                if(isempty(S{i}))
                    continue;
                end
                for j = 1 : row(S{i})
                    c        = FoldCurve();
                    c.Mesh   = MeshHandle;
                    c.Skin   = SkinHandle;
                    c.Point  = S{i}(j).B;
                    c.Edge   = S{i}(j).E;
                    c.Face   = S{i}(j).T;
                    c.Handle = i;
                    c.updateFrenetFrames();
                    C        = [C;c];
                end
            end
        end
    end
end