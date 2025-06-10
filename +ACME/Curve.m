classdef Curve < handle
    properties
        Parent
        
        Index
        Edge
        Handle
        
        Tangent
        Normal
        Bitangent
        Param
    end
    
    methods
        function [obj] = Curve(Parent,Index,Edge,Handle)
            obj.Parent = Parent;
            obj.Index  = Index;
            obj.Edge   = Edge;
            obj.Handle = Handle;
            obj.computeCurveData();
        end
        
        function computeCurveData(obj)
            f = @(e,d) normr(accumarray3([e(:,1);e(:,2)],[d;d],[numel(obj.Index),1]));
            P = obj.get('Point');
            N = obj.get('Normal');
            T = P(obj.Edge(:,2),:)-P(obj.Edge(:,1),:);
            N = cross(T,N(obj.Edge(:,1),:)+N(obj.Edge(:,2),:),2);
            B = cross(T,N,2);
            obj.Tangent   = f(obj.Edge,T);
            obj.Normal    = f(obj.Edge,N);
            obj.Bitangent = f(obj.Edge,B);
            L         = [0;vecnorm3(T)];
            obj.Param = cumsum(L)./sum(L);
        end
        
        function [h] = show(obj,varargin)
            P = obj.Parent.Point(obj.Index,:);
            h = display_curve(P,obj.Edge,varargin{:});
        end
        
        function [val] = get(obj,propname,i)
            if(nargin<3)
                i = (1:numel(obj.Index))';
            end
            val = obj.Parent.(propname)(obj.Index(i),:);
        end
        
        function [val] = average(obj,propname,i)
            if(nargin<3)
                i = (1:numel(obj.Index))';
            end
            val = mean(obj.get(propname,i));
        end
        
        function [i] = index(obj,i)
            if(iscolumn(i))
                i = i';
            end
            i = find(sum(i==obj.Index,2));
        end
        
        function smoothCurveData(obj,iteration)
            if(nargin<2)
                iteration = 10;
            end
            
%             P  = obj.get('Point');
%             N = obj.get('Normal');
            
            E  = obj.Edge;
            
            T = obj.Tangent;
            N = obj.Normal;
            B = obj.Bitangent;
            for i = 1 : iteration
                T = normr(T(E(:,1),:)+T(E(:,2),:));
            end
            obj.Tangent   = T;
            obj.Normal    = N;
            obj.Bitangent = B;
        end
    end
end