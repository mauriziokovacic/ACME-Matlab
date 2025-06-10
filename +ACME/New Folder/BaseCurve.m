classdef BaseCurve < dynamicprops
    properties( Access = public, SetObservable )
        Point     {mustBeNumeric, mustBeFinite}
        Edge(:,2) {mustBeNumeric, mustBeInteger,...
                   mustBeFinite, mustBeGreaterThan(Edge,0)}
        Name(1,:) char = ''
    end
    
    properties( Dependent = true, SetAccess = public )
        Tangent
        Normal
        Bitangent
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = BaseCurve(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Point', [], @(data) isnumeric(data));
            addParameter( parser, 'Edge',  [], @(data) isnumeric(data));
            addParameter( parser, 'Name',  '', @(data) isstring(data)||ischar(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function [C] = copy(obj)
            C = [];
            for i = 1 : numel(obj)
                C = [C;BaseCurve('Point',obj(i).Point,...
                                 'Edge',obj(i).Edge,...
                                 'Name',[obj(i).Name,'-Copy'])];
            end
        end
        
        function [tf] = is_closed(obj)
            tf = arrayfun(@(o) o.Edge(1)==o.Edge(end), obj);
        end
        
        function [tf] = is_open(obj)
            tf = arrayfun(@(o) o.Edge(1)~=o.Edge(end), obj);
        end
        
        function closed2open(obj)
            for i = 1 : numel(obj)
                C = obj(i);
                if( is_closed(C) )
                    C.Point = [C.Point;C.Point(C.Edge(end),:)];
                    C.Edge  = [C.Edge; row(C.Point)];
                end
            end
        end
        
        function open2closed(obj)
            for i = 1 : numel(obj)
                C = obj(i);
                if( is_open(C) )
                    C.Edge = [C.Edge; rot90(C.Edge,2)];
                end
            end
        end
        
        function reorder(obj)
            for i = 1 : numel(obj)
                C = obj(i);
                C.Point = getOrderedPoint(C);
                if( is_closed(C) )
                    C.Point = C.Point(1:end-1,:);
                end
                C.Edge = reshape(reindex(C.Edge),row(C.Edge),2);
            end
        end
        
        function [n] = n_point(obj)
            n = arrayfun(@(o) row(o.Point), obj);
        end
        
        function [l] = length(obj)
            l = arrayfun(@(o) sum(distance(o.Point(o.Edge(:,1),:),...
                                           o.Point(o.Edge(:,2),:),...
                                           2)),...
                         obj);
        end
        
        function [A,B] = segment(obj)
            n = numel(obj);
            A = cell(n,1);
            B = cell(n,1);
            for i = 1 : n
                C = obj(i);
                P = getOrderedPoint(C);
                A{i} = P(1:end-1,:);
                B{i} = P(2:end  ,:);
            end
            if( n==1 )
                A = A{1};
                B = B{1};
            end
        end
        
        function [t] = parameter(obj)
            t = cell(numel(obj),1);
            for i = 1 : numel(obj)
                C    = obj(i);
                P    = C.getOrderedPoint();
                t{i} = distance(P([1;(1:row(P)-1)'],:),P,2);
                t{i} = cumsum(t{i})./sum(t{i});
            end
            if(numel(obj)==1)
                t = t{1};
            end
        end
        
        function [Q, t] = project_point_on_curve(obj, P, varargin)
            [A,B] = obj.segment();
            T     = obj.parameter();
            T     = [T(1:end-1) T(2:end)];
            [Q,a] = project_point_on_segment(A, B, P);
            k     = min_index(distance(Q, P, 2));
            t     = (1-a(k)) * T(k,1) + a(k) * T(k,2);
            Q     = obj.fetchData({'Point'}, t, varargin{:});
        end
        
        function [X] = getData(obj, propName, order)
            X = [];
            if( nargin < 3 )
                order = 'stable';
            end
            switch lower(order)
                case 'stable'
                    for i = 1 : numel(obj)
                        X = [X;obj(i).(propName)];
                    end
                case 'sort'
                    for i = 1 : numel(obj)
                        E = [obj(i).Edge(:,1);obj(i).Edge(end)];
                        X = [X;obj(i).(propName)(E,:)];
                    end
                otherwise
                    error('Unknown order.');
            end
        end
        
        function [varargout] = fetchData(obj, propName, t, varargin)
            n = numel(obj);
            if( ~iscell(t) )
                t = repmat({t}, n, 1);
            end
            if( ~iscell(propName) )
                propName = {propName};
            end
            for i = 1:nargout
                varargout{i} = cell(n,1);
            end
            for i = 1 : n
                C = obj(i);
                x = parameter(C);
                if( is_closed(C) )
                    x = [x(end-2:end-1,:)-1; x; x(2:3,:)+1];
                end
                for p = 1 : numel(propName)
                    v = getData(C,propName{p},'sort');
                    if( is_closed(C) )
                        v = [v(end-2:end-1,:);   v; v(2:3,:)];
                    end
                    [x,ix] = uniquetol(x,0.0001);
                    v = v(ix,:);
                    varargout{p}{i} = interp1(x,full(v),make_column(t{i}), varargin{:});
                end
            end
            if( n==1 )
                for i = 1:nargout
                    out          = varargout{i};
                    varargout{i} = out{1};
                end
            end
        end
        
        function [P] = fetchPoint(obj, t, varargin)
            P = fetchData(obj, 'Point', t, varargin{:});
        end
        
        function [P] = getPoint(obj)
            P = getData(obj, 'Point', 'stable');
        end
        
        function [P] = getOrderedPoint(obj)
            P = getData(obj, 'Point', 'sort');
        end
        
        function [T] = fetchTangent(obj, t, varargin)
            T = fetchData(obj, 'Tangent', t, varargin{:});
        end
        
        function [T] = getTangent(obj)
            T = getData(obj, 'Tangent', 'stable');
        end
        
        function [T] = getOrderedTangent(obj)
            T = getData(obj, 'Tangent', 'sort');
        end
        
        function [N] = fetchNormal(obj, t, varargin)
            N = fetchData(obj, 'Normal', t, varargin{:});
        end
        
        function [N] = getNormal(obj)
            N = getData(obj, 'Normal', 'stable');
        end
        
        function [N] = getOrderedNormal(obj)
            N = getData(obj, 'Normal', 'sort');
        end
        
        function [B] = fetchBitangent(obj, t, varargin)
            B = fetchData(obj, 'Bitangent', t, varargin{:});
        end
        
        function [B] = getBitangent(obj)
            B = getData(obj, 'Bitangent', 'stable');
        end
        
        function [B] = getOrderedBitangent(obj)
            B = getData(obj, 'Bitangent', 'sort');
        end
        
        function [mel] = toMELScript(obj)
            mel = [];
            for i = 1 : numel(obj)
                C   = obj(i);
                P   = getOrderedPoint(C);
                mel = [mel,curve2MEL(P)];
            end
            mel = mel(1:end-1);
        end
        
        function [h] = show(obj,varargin)
            offset = 0;
            P = [];
            E = [];
            for i = 1 : numel(obj)
                C = obj(i);
                P = [P; getPoint(C)];
                E = [E; C.Edge+offset];
                offset = offset + row(C.Point);
            end
            h = display_curve(P, E, varargin{:});
        end
    end
    
    methods
        function [T] = get.Tangent(obj)
            T = get_tangent(obj);
        end
        
        function set.Tangent(obj,varargin)
            set_tangent(obj,varargin{:});
        end
        
        function [N] = get.Normal(obj)
            N = get_normal(obj);
        end
        
        function set.Normal(obj,varargin)
            set_normal(obj,varargin{:});
        end
        
        function [B] = get.Bitangent(obj)
            B = get_bitangent(obj);
        end
        
        function set.Bitangent(obj,varargin)
            set_bitangent(obj,varargin{:});
        end
    end
    
    methods( Access = protected )
        function [T] = get_tangent(obj)
            T = [];
            for i = 1 : numel(obj)
                C = obj(i);
                P = getData(C,'Point','sort');
                if( is_closed(C) )
                    P = [P(end-1,:);P];
                else
                    P = [P(1,:);P;P(end,:)];
                end
                t = normr(P(3:end,:)-P(1:end-2,:));
                if( is_open(C) )
                    e = [C.Edge(:,1); C.Edge(end)];
                else
                    e = C.Edge(:,1);
                end
                t(e,:) = t;
                T = [T;t];
            end
        end
        
        function set_tangent(obj,varargin)
        end
        
        function [N] = get_normal(obj)
            N = [];
            for i = 1 : numel(obj)
                C = obj(i);
                T = getData(C,'Tangent','sort');
                if( is_closed(C) )
                    T = [T(end-1,:);T];
                else
                    T = [T(1,:);T;T(end,:)];
                end
                n = normr(T(3:end,:)-T(1:end-2,:));
                if( is_open(C) )
                    e = [C.Edge(:,1); C.Edge(end)];
                else
                    e = C.Edge(:,1);
                end
                n(e,:) = n;
                N = [N;n];
            end
        end
        
        function set_normal(obj,varargin)
        end
        
        function [B] = get_bitangent(obj)
            B = normr(cross(obj.Tangent, obj.Normal,2));
        end
        
        function set_bitangent(obj,varargin)
        end
    end
end