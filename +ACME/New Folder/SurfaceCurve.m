classdef SurfaceCurve < StandardCurve
    properties( Access = public, SetObservable )
        Mesh % Mesh handle
        Face
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = SurfaceCurve(varargin)
            obj@StandardCurve(varargin{:});
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Mesh', [], @(data) isa(data,'AbstractMesh'));
            addParameter( parser, 'Face', [], @(data) isnumeric(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function [P] = surfacePoint(obj,i)
            if((nargin<2)||isempty(i))
                i = (1:row(obj.Point))';
            end
            P = surfaceData(obj,obj.Mesh.Vertex,i);
        end
        
        function [T] = surfaceTangent(obj,i)
            if((nargin<2)||isempty(i))
                E = sortrows(obj.Edge);
                i = E(:,1);
            end
            P = surfacePoint(obj,i);
            T = normr(P(E(:,2),:)-P);
        end
        
        function [N] = surfaceNormal(obj,i)
            if((nargin<2)||isempty(i))
                i = (1:row(obj.Point))';
            end
            N = normr(surfaceData(obj,obj.Mesh.Normal,i));
        end
        
        function [B] = surfaceBitangent(obj,i)
            if((nargin<2)||isempty(i))
                E = sortrows(obj.Edge);
                i = E(:,1);
            end
            T = surfaceTangent(obj);
            N = surfaceNormal(obj,i);
            B = normr(cross(T,N,2));
        end
        
        function [UV] = surfaceUV(obj,i)
            if((nargin<2)||isempty(i))
                i = (1:row(obj.Point))';
            end
            UV = surfaceData(obj,obj.Mesh.UV,i);
        end
        
        function [out] = surfaceData(obj,VertexData,i)
            out = [];
            for c = 1 : numel(obj)
                C = obj(c);
                if((nargin<3)||isempty(i))
                    i = (1:row(C.Point))';
                end
                out = [out;from_barycentric(VertexData,...
                                            C.Mesh.Face,...
                                            C.Face(i,:),...
                                            C.Point(i,:))];
            end
        end
        
        function [C] = toStandardCurve(obj)
            C = StandardCurve('Point',getPoint(obj),...
                              'Edge', obj.Edge,...
                              'Name', obj.Name,...
                              'Tangent',obj.Tangent,...
                              'Normal',obj.Normal,...
                              'Bitangent',obj.Bitangent);
        end
        
        function [S] = curve2segment(obj)
            E = obj.Edge;
            t = obj.Face;
            P = obj.Point;
            I = find(t(E(:,1)) == t(E(:,2)));
            J = setdiff((1:row(E))',I);
            S = struct('A',zeros(row(E),3),'B',zeros(row(E),3),'T',zeros(row(E),1));
            for n = 1 : numel(I)
                i = I(n);
                S.A(i,:) = P(E(i,1),:);
                S.B(i,:) = P(E(i,2),:);
                S.T(i,:) = t(E(i,1));
            end
            if(~isempty(J))
                warning('Function works only if points comes from adjacent triangles.');
                T = obj.Mesh.Face;
                for n = 1 : numel(J)
                    j  = J(n);
                    b  = zeros(1,3);
                    Ti = T(t(E(j,1)),:);
                    Tj = T(t(E(j,2)),:);
                    for k = 1 : 3
                        b(Tj(k)==Ti) = P(E(j,2),Tj(k)==Ti);
                    end
                    S.A(j,:) = P(E(j,1),:);
                    S.B(j,:) = b;
                    S.T(j,:) = t(E(j,1));
                end
            end
        end
    end
    
    methods( Access = public )
        function [P] = getPoint(obj)
            P = surfacePoint(obj);
        end
        
        function [N] = getNormal(obj)
            N = surfaceNormal(obj);
        end
        
        function computeNormal(obj)
%             f = @(e,d) normr(accumarray3([e(:,1);e(:,2)],[d;d],[row(obj.Point),1]));
%             P = getPoint(obj);
            obj.Normal = surfaceNormal(obj);
%             T = P(obj.Edge(:,2),:)-P(obj.Edge(:,1),:);
%             N = f(obj.Edge,cross(T,N(obj.Edge(:,1),:)+N(obj.Edge(:,2),:),2));
        end
    end
    
    methods( Static )
        function [C] = createFromField(MeshHandle,Field,iso)
            if( nargin < 3 )
                iso = 0.5;
            end
            S = createCurveFromField(MeshHandle,Field,iso);
            C = [];
            for i = 1 : row(S)
                if(isempty(S{i}))
                    continue;
                end
                for j = 1 : row(S{i})
                    c       = SurfaceCurve();
                    c.Mesh  = MeshHandle;
                    c.Point = S{i}(j).B;
                    c.Edge  = S{i}(j).E;
                    c.Face  = S{i}(j).T;
                    c.updateFrenetFrames();
                    C       = [C;c];
                end
            end
        end
    end
end