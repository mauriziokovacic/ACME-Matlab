classdef AbstractCurve < handle
    properties( Access = public, SetObservable )
        Point
        Edge
        Name
        
        Tangent
        Normal
        Bitangent
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = AbstractCurve(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Point',     [], @(data) isnumeric(data));
            addParameter( parser, 'Edge',      [], @(data) isnumeric(data)&&col(data)==2);
            addParameter( parser, 'Name',      '', @(data) isstring(data)||ischar(data));
            addParameter( parser, 'Tangent',   [], @(data) isnumeric(data));
            addParameter( parser, 'Normal',    [], @(data) isnumeric(data));
            addParameter( parser, 'Bitangent', [], @(data) isnumeric(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function [n] = nPoint(obj)
            n = arrayfun(@(c) row(c.Point),obj);
        end
        
        function [P] = getOrderedPoint(obj)
            P = getPoint(obj);
            E = obj.Edge;
            P = [P(E(:,1),:);P(E(end),:)];
        end
        
        function [T] = tangent(obj)
            T = obj.Tangent;
        end
        
        function [N] = normal(obj)
            N = obj.Normal;
        end
        
        function [B] = bitangent(obj)
            B = obj.Bitangent();
        end
        
        function updateFrenetFrames(obj)
            computeTangent(obj);
            computeNormal(obj);
            computeBitangent(obj);
        end
        
        function [L] = length(obj)
            P = getPoint(obj);
            E = P(obj.Edge(:,2),:)-P(obj.Edge(:,1),:);
            L = sum(vecnorm3(E));
        end
        
        function [t] = parameter(obj)
            P = getPoint(obj);
            E = P(obj.Edge(:,2),:)-P(obj.Edge(:,1),:);
            t = [0;vecnorm3(E)];
            t = cumsum(t)./sum(t);
        end
        
        function [C] = from_param(obj, t, varargin)
            alpha = parameter(obj);
            P     = getOrderedPoint(obj);
            C     = interp1(alpha,P,t, varargin{:});
        end
        
        function [A,B] = extract_segments(obj)
            A = [];
            B = [];
            for i = 1 : numel(obj)
                c = obj(i);
                P = getOrderedPoint(c);
                A = [A;P(1:end-1,:)];
                B = [B;P(2:end,:)];
            end
        end
        
        function [h] = show(obj,varargin)
            offset = 0;
            P = [];
            E = [];
            for i = 1 : numel(obj)
                o = obj(i);
                P = [P;getPoint(o)];
                E = [E;o.Edge+offset];
                offset = offset + row(o.Point);
            end
            h = display_curve(P,E,varargin{:});
        end
        
        function update(obj, h)
            P = cell2mat(arrayfun(@(c) getPoint(c), obj, 'UniformOutput',false));
            set(h, 'Vertices', P);
        end
        
        function [M] = toMesh(obj)
            M = AbstractMesh('Vertex',getPoint(obj),...
                             'Normal',zeros(size(obj.Point)),...
                             'UV',zeros(row(obj.Point),2),...
                             'Face',edge2tri(obj.Edge),...
                             'Name',obj.Name);
        end
        
        function [mel] = toMelScript(obj)
            mel = [];
            for k = 1 : numel(obj)
                C = obj(k);
                E = C.Edge;
                P = getPoint(C);
                P = P([E(:,1);E(end)],:);
                P(abs(P)<0.0001) = 0;
                mel = [mel,curve2MEL(P)];
            end
            mel = mel(1:end-1);
        end
    end
    
    methods( Access = public )
        function [P] = getPoint(obj)
            P = obj.Point;
        end
        
        function [N] = getNormal(obj)
            N = obj.Normal;
        end
        
        function [T] = getTangent(obj)
            T = obj.Tangent;
        end
        
        function [B] = getBitangent(obj)
            B = obj.Bitangent;
        end
    end
    
    methods( Access = public, Abstract )
        computeTangent(obj)
        computeNormal(obj)
        computeBitangent(obj)
    end
end