classdef AbstractContact < handle
    properties( Access = public, SetObservable )
        Mesh % Mesh handle
        Skin % Skin handle
        Curve
        CPoint
        Point
        Normal
        Weight
        Value
        Name
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = AbstractContact(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Mesh',   [], @(data) isa(data,'AbstractMesh'));
            addParameter( parser, 'Skin',   [], @(data) isa(data,'AbstractSkin'));
            addParameter( parser, 'Curve',  [], @(data) isscalar(data));
            addParameter( parser, 'Point',  [], @(data) isnumeric(data));
            addParameter( parser, 'Normal', [], @(data) isnumeric(data));
            addParameter( parser, 'Weight', [], @(data) isnumeric(data));
            addParameter( parser, 'Value',  [], @(data) isnumeric(data));
            addParameter( parser, 'Name',   '', @(data) isstring(data)||ischar(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function load(obj,filename)
            copy(obj,AbstractContact.LoadFromFile(filename));
        end
        
        function save(obj,filename)
            AbstractContact.SaveToFile(obj,filename);
        end
        
        function copy(obj,other)
            prop = properties(obj);
            for i = 1 : numel(prop)
                obj.(prop{i}) = other.(prop{i});
            end
        end
        
        function [fig] = show(obj)
            fig = CreateViewer3D('right');
            h = display_mesh(obj.Mesh.Vertex,...
                             obj.Mesh.Normal,...
                             obj.Mesh.Face,...
                             obj.Value);
            h.HandleVisibility = 'off';
            hold on;
            function event(x)
                persistent k;
                if(isempty(k))
                    k = 0;
                end
                delete(get_point(handle(gca)));
                delete(get_patch(handle(gca)));
                i = obj.Mesh.knn(x);
                if(i~=k)
                    point3(obj.Mesh.Vertex(i,:),40,'filled','r');
                    point3(obj.Point(i,:),40,'filled','b');
                    plane3(obj.Point(i,:),obj.Normal(i,:),0.2*mesh_scale(obj.Mesh.Vertex),[1 1 0 0.2],'HitTest','off','PickableParts','none');
                    k = i;
                else
                    k = 0;
                end
            end
            h.ButtonDownFcn = @(o,e) event(e.IntersectionPoint);
        end
    end
    
    methods( Access = public )
        function computeContact(obj,CData,index)
            if(nargin<3)
                index = [];
            end
            n = obj.Mesh.nVertex();
            if(isempty(index))
                index = 1:n;
            end
            if((nargin<2)||isempty(CData))
                CData = FoldCurve.createFromSkin(obj.Mesh,obj.Skin);
            end
            C  = cell(n,1);
            P  = cell(n,1);
            P_ = cell(n,1);
            N_ = cell(n,1);
            W_ = cell(n,1);

            if( numel(index) == n )
                parfor i = index
                    [C{i},P{i},P_{i},N_{i},W_{i}] = compute_vertex_contact(obj,CData,i);
                end
            else
                for i = index
                    [C{i},P{i},P_{i},N_{i},W_{i}] = compute_vertex_contact(obj,CData,i);
                end
            end

            C  = cell2mat(C);
            P  = cell2mat(P);
            P_ = cell2mat(P_);
            N_ = cell2mat(N_);
            N_ = reorient_plane(P_,N_,obj.Mesh.Vertex(index,:));
            W_ = cell2mat(W_);
            W_ = W_./sum(W_,2);
            U  = 1-normalize(distance(obj.Mesh.Vertex(index,:),P_));
            
            obj.Curve  = C;
            obj.CPoint = P;
            obj.Point  = P_;
            obj.Normal = N_;
            obj.Weight = W_;
            obj.Value  = U;
        end
        
        function [c,k,P_,N_,W_] = compute_vertex_contact(obj,CData,I)
            Pi = obj.Mesh.Vertex(I,:);
            Ni = obj.Mesh.Normal(I,:);
            Wi = obj.Skin.Weight(I,:);
            c  = findCurve(CData,Pi,Wi);
            if(~isempty(c))
                C  = CData(c);
                k  = findCurveProjection(C,Pi,Ni,Wi);
                [P_,N_,W_] = findContactData(C,k,Pi,Ni,obj.Mesh);
            else
                c  = 0;
                k  = 0;
                P_ = Pi;
                N_ = [0 0 0];
                W_ = Wi;
            end
        end
    end
    
    methods( Static )
        function [obj] = LoadFromFile(filename)
            obj = [];
            [path,name,ext] = fileparts(filename);
            filename = strcat(path,'/',name);
            switch lower(ext)
                case '.cnt'
                    [P,N,W,~,~,U] = import_CNT(filename);
                otherwise
                    warning('File extension not supported');
                    return;
            end
            obj = AbstractContact('Point',P,'Normal',N,'Weight',W,'Value',U,'Name',name);
        end
        
        function SaveToFile(C,filename)
            [path,name,ext] = fileparts(filename);
            switch lower(ext)
                case '.cnt'
                    export_CNT([path,filesep,name],...
                               C.Point,...
                               C.Normal,...
                               C.Weight,...
                               point_plane_distance(C.Point,C.Normal,C.Mesh.Vertex),...
                               dotN(C.Mesh.Normal,C.Normal),...
                               C.Value);
                case '.off'
                    export_OFF(filename,...
                               'Point',C.Point);
                case '.obj'
                    export_OBJ(filename,...
                               'Point',C.Point,...
                               'UV',[C.Value zeros(size(C.Value))],...
                               'Normal',C.Normal);
                otherwise
                    warning('File extension not supported');
                    return;
            end
        end
    end
end

function [i] = findCurve(CData,Pi,Wi)
    i = possible_vertex_curve(CData,Wi);
    i = closest_curve(CData,Pi,i);
end

function [k] = findCurveProjection(C,Pi,Ni,Wi)
    s  = 1-2*(Wi(C.getHandle())>=0.5);
    P  = getPoint(C);
    T  = s.* tangent(C);
    D  = distance(P,Pi);
    U  = (P-Pi)./D;
    E  = cell2mat(arrayfun(@(i) det([U(i,:);Ni;T(i,:)]),...
                           1:row(P),...
                           'UniformOutput',false))';
	E = E + D.^2;
    k = min_index(E);
end

function [P_,N_,W_] = findContactData(C,k,Pi,Ni,M)
    P  = getPoint(C);
    P_ = P(k,:);
    r  = distance(Pi,P_);
    if(r<0.0001)
        N_ = [0 0 0];
        W_ = getWeight(C,k);
        return;
    end
    N  = normal(C);
    W  = getWeight(C);
    d  = distance(P,P_);
    i  = find(d<=r);
    w  = 1-(d(i)./r);
    P_ =       sum(w.*P(i,:),1)./sum(w);
    N_ = normr(sum(w.*N(i,:),1)./sum(w));
    W_ =       sum(w.*W(i,:),1)./sum(w);
    W_ = W_./sum(W_,2);
end

function [i] = possible_vertex_curve(CData,W)
    [~,c,w] = find(W);
    [w,n] = sort(w,'descend');
    if(w(1)>=0.5)
        c = c(n(1));
    end
    i = find(cell2mat(arrayfun(@(k) any(CData(k).getHandle()==c),(1:row(CData))','UniformOutput',false)));
end

function [i] = closest_curve(CData,P,curveIndex)
    d = cell2mat(arrayfun(@(k) min(distance(P,CData(k).getPoint())),curveIndex,'UniformOutput',false));
    i = curveIndex(min_index(d));
end