classdef ContactCurve < AbstractCurve
    properties( Access = public, SetObservable )
        Fold
        Orientation
        Weight
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = ContactCurve(varargin)
            obj@AbstractCurve(varargin{:})
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Fold',        [], @(data) isa(data,'FoldCurve'));
            addParameter( parser, 'Orientation', [], @(data) isnumeric(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function [h] = getHandle(obj)
            h = obj.Fold.Handle;
        end
        
        function [W] = getWeight(obj,i)
            if((nargin<2)||isempty(i))
                i = (1:row(obj.Point))';
            end
            W = obj.Weight(i,:);
        end
        
        function recompute(obj,res)
            FC = obj.Fold;
            t  = parameter(FC);
            q  = linspace(0,1,clamp(row(FC.Point),4,res));
            P  = getPoint(FC);
            N  = surfaceNormal(FC);
            W  = surfaceWeight(FC);
            e  = FC.Edge;
            P  = [P(e(:,1),:);P(e(end),:)];
            N  = [N(e(:,1),:);N(e(end),:)];
            W  = [W(e(:,1),:);W(e(end),:)];

            P = interp1(t,P,q,'pchip');
            N = interp1(t,N,q,'pchip');
            W = sparse(interp1(t,full(W),q,'pchip'));
            
            E = [(1:row(P)-1)' (2:row(P))'];
            if(e(end)==e(1))
                P(end,:) = [];
                N(end,:) = [];
                W(end,:) = [];
                E(end)   = E(1);
            end
            
            obj.Point       = P;
            obj.Orientation = N;
            obj.Weight      = W;
            obj.Edge        = E;
            obj.updateFrenetFrames();
        end
        
        function resample(obj,res)
            t  = parameter(obj);
            q  = linspace(0,1,res);
            e  = obj.Edge;
            prop = properties(obj);
            prop(strcmpi(prop,'Edge')) = [];
            prop(strcmpi(prop,'Fold')) = [];
            prop(strcmpi(prop,'Name')) = [];
            for i = 1 : numel(prop)
                if(issparse(obj.(prop{i})))
                    obj.(prop{i}) = sparse(interp1(t,full(obj.(prop{i})([e(:,1);e(end)],:)),q,'pchip'));
                else
                    obj.(prop{i}) = interp1(t,obj.(prop{i})([e(:,1);e(end)],:),q,'pchip');
                end
            end
            E = [(1:row(obj.Point)-1)' (2:row(obj.Point))'];
            if(e(end)==e(1))
                for i = 1 : numel(prop)
                    obj.(prop{i})(end,:) = [];
                end
                E(end) = E(1);
            end
            obj.Edge = E;
        end
    end
    
    methods( Access = public )
        function computeTangent(obj)
            f = @(e,d) normr(accumarray3([e(:,1);e(:,2)],[d;d],[row(obj.Point),1]));
            P = getPoint(obj);
            obj.Tangent = f(obj.Edge,P(obj.Edge(:,2),:)-P(obj.Edge(:,1),:));
        end
        
        function computeNormal(obj)
            for n = 1 : numel(obj)
                c = obj(n);
                P = getPoint(c);
                N = c.Orientation;
                C = mean(P);
                r = distance(P,C);
                T = tangent(c);
                c.Normal = zeros(size(P));
                for i = 1 : row(P)
                    v = c.Fold.Mesh.rnn(P(i,:),r(i));
                    U = c.Fold.Mesh.Normal(v,:);
                    U = U(dotN(U,N(i,:))>0,:);
                    c.Normal(i,:) = normr(mean(U));
                end
                c.Normal = cross(T,c.Normal,2);
            end
        end
        
        function computeBitangent(obj)
            obj.Bitangent = normr(cross(obj.Tangent,obj.Normal,2));
        end
    end
    
    methods( Access = public, Static )
        function [obj] = createFromFold(Curve)
            obj = [];
            for i = 1 : numel(Curve)
                FC = Curve(i);
                if(~isa(FC,'FoldCurve'))
                    continue;
                end
                C = ContactCurve('Fold',FC);
                recompute(C,100);
%                 resample(C,clamp(50,4,row(FC.getPoint())));
                obj = [obj;C];
            end
        end
    end
end