classdef CurveSet < handle
    properties
        Point
        Normal
        UV
        Face
        Weight
        Bary
        
        CData
        CurveID
    end
    
    properties( Access = private )
        PTree
        NTree
        WTree
    end
    
    methods
        function [obj] = CurveSet(varargin)
            obj.reset();
        end
        
        function addCurve(obj,C)
            offset     = row(obj.Point);
            obj.Point  = [obj.Point;C.P];
            obj.Normal = [obj.Normal;C.N];
            obj.UV     = [obj.UV;zeros(row(C.P),2)];%C.UV];
            obj.Weight = [obj.Weight;C.W];
            obj.Face   = [obj.Face;C.T];
            obj.Bary   = [obj.Bary;C.B];
            obj.CData  = [obj.CData;Curve(obj,(1:row(C.P))'+offset,C.E,C.h)];
        end
        
        function recompute(obj,propname,data,T)
            obj.(propname) = from_barycentric(data,T,obj.Face,obj.Bary);
        end

        function compact(obj)
            [obj.Point,i,j] = uniquetol(obj.Point,0.0001,'ByRows',true);
            obj.Normal      = obj.Normal(i,:);
            obj.UV          = obj.UV(i,:);
            obj.Weight      = obj.Weight(i,:);
            obj.Face        = obj.Face(i,:);
            obj.Bary        = obj.Bary(i,:);
            for c = 1 : row(obj.CData)
                obj.CData(c).Index = j(obj.CData(c).Index);
            end
        end
        
        function update(obj)
            obj.compact();
            obj.PTree   = KDTreeSearcher(obj.Point);
            obj.NTree   = ExhaustiveSearcher(obj.Normal,'Distance',@(a,b) 0.5*(1-dotN(a,b)));
            obj.WTree   = ExhaustiveSearcher(obj.Weight);
            obj.CurveID = cell(row(obj.Point),1);
            for i = 1 : row(obj.CData)
                c = obj.CData(i);
                for j = 1 : numel(c.Index)
                    obj.CurveID{c.Index(j)} = [obj.CurveID{c.Index(j)};i];
                end
            end
        end
        
        function [out] = get(obj,propname,curveID,pointID)
            out = obj.(propname)(obj.CData(curveID).Index(pointID),:);
        end
        
        function [out] = closest(obj,val,type,k)
            if(nargin<4)
                k = 1;
            end
            type = upper(type(1));
            out = unique(cell2mat(knnsearch(obj.(strcat(type,'Tree')),val,'K',k,'IncludeTies',true)));
        end
        
        function [out] = range(obj,val,type,r)
            if(nargin<4)
                r = 1;
            end
            type = upper(type(1));
            out = unique(cell2mat(rangesearch(obj.(strcat(type,'Tree')),val,r)));
        end
        
        function [h] = show(obj,index,varargin)
            if((nargin<2)||isempty(index))
                E = [];
                for i = 1 : row(obj.CData)
                    c = obj.CData(i);
                    E = [E;c.Index(c.Edge)];
                end
                E = unique(sort(E,2),'rows');
                h = display_curve(obj.Point,E,varargin{:});
            else
                h = [];
                C = scatter_color(row(obj.CData),index);
                for i = index
                    h = [h;obj.CData(i).show('EdgeColor',C(i,:),varargin{:})];
                end
            end
        end
        
        function reset(obj)
            obj.Point     = [];
            obj.Normal    = [];
            obj.UV        = [];
            obj.Face      = [];
            obj.Weight    = [];
            obj.Bary      = []; 
            obj.CData     = [];
            obj.CurveID   = [];
            obj.PTree     = [];
            obj.NTree     = [];
            obj.WTree     = [];
        end
        
        function fromMesh(obj,P,N,UV,T,W)
            obj.reset();
            S = meandering_triangle(T,W);
%             S = subdivide_segment(S);
            for i = 1 : row(S)
                if(~isempty(S{i}))
                    S{i} = obj.buildCurveEdge(P,T,S{i});
                    S{i} = obj.splitCData(S{i});
                    for j = 1 : row(S{i})
                        C = obj.buildCData(P,N,UV,T,W,i,S{i}(j));
                        obj.addCurve(C);
                    end
                end
            end
            if(~isempty(obj.CData))
                obj.update();
            end
        end
    end
    
    methods( Access = private )
        function [S] = buildCurveEdge(obj,P,T,S)
            s    = struct('B',[],'T',[],'E',[]);
            s.B  = interleave(S.A,S.B);
            s.T  = repelem(S.T,2,1);
            P    = from_barycentric( P,T,s.T,s.B);
            s.E  = reshape(1:row(s.B),2,floor(row(s.B)/2))';
            [~,j,k] = uniquetol(P,0.0001,'ByRows',true);
            s.B  =  s.B(j,:);
            s.T  =  s.T(j,:);
            s.E  =  k(s.E);
            s.E(s.E(:,1)==s.E(:,2),:) = [];
            S = s;
        end
        
        function [C] = splitCData(obj,S)
            [S.E,E] = obj.findSingleCurve(S.E);
            C = repmat(emptyStruct(S),numel(E),1);
            for i = 1 : numel(E)
                [C(i).E,I] = reindex(S.E(E{i},:));
                C(i).B = S.B(I,:);
                C(i).T = S.T(I,:);
            end
        end
        
        function [E,I] = findSingleCurve(obj,E)
            % find possible roots
            R = [];
            % [~,R] = duplicated(E(:,1));
            R = [R;find(~ismember(E(:,1),E(:,2)))];

            I = [];
            if( isempty(R) )
                [~,R] = duplicated(E(:,1));
                R = setdiff(1:row(E),R);
                R = R(1);
            end

            e = E(R(1),:);
            Q = E(setdiff(1:row(E),R(1)),:);
            R(1) = [];
            first = 1;
            while(~isempty(Q))
                j = find(Q(:,1)==e(end,2));
                if(e(end,2)==e(first,1))
                    I = [I;{(first:row(e))'}];
                    first = row(e)+1;
                end
                if(isempty(j))
                    I = [I;{(first:row(e))'}];
                    first = row(e)+1;
                    if(isempty(R))
                        j = 1;
                    else
                        j = find((Q(:,1)==E(R(1),1))&(Q(:,2)==E(R(1),2)));
                        R(1) = [];
                        if(isempty(j))
                            j = 1;
                        end
                    end
                end
                j = j(1);
                e = [e;Q(j,:)];
                Q(j,:)=[];
            end
            I = [I;{(first:row(e))'}];
            I = erase_empty(I);
            E = e;
        end
        
        function [C] = buildCData(obj,P,N,UV,T,W,h,C)
            c    = struct('B',[],'T',[],'E',[],'P',[],'N',[],'UV',[],'W',[],'h',[]);
            c.B  = C.B;
            c.T  = C.T;
            c.E  = C.E;
            c.P  = from_barycentric( P,T,c.T,c.B);
            c.N  = from_barycentric( N,T,c.T,c.B);
            c.UV = from_barycentric(UV,T,c.T,c.B);
            c.W  = from_barycentric( W,T,c.T,c.B);
            c.h  = h;
            C    = c;
        end
    end
end