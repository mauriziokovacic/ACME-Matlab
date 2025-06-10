classdef Op < handle
    properties
        U
        V
        Scale
    end
    
    methods
        function obj = Op(varargin)
            obj.U = [];
            obj.V = [];
            obj.Scale = 1;
            if( nargin >= 2 )
                s = varargin{2};
            else
                s = 1;
            end
            if( nargin >= 1 )
                n = varargin{1};
            else
                n = [10 10];
            end
            obj = obj.reset(n,s);
        end
        
        function obj = reset(obj, n, s)
            if( numel(n) == 1 )
                obj.U = cell(n,1);
                obj.V = cell(n,1);
                for i = 1 : n
                    obj.U{i} = linspace(0,1,n)';
                    obj.V{i} = repmat(0.5,n,1);
                end
            else
                obj.U = cell(n(1),1);
                obj.V = cell(n(1),1);
                for i = 1 : n
                    obj.U{i} = linspace(0,1,n(2))';
                    obj.V{i} = repmat(0.5,n(2),1);
                end
            end
            obj.Scale = s;
        end
        
        function s = size(obj)
            s = size(obj.U,1);
        end
        
        
        function show(obj,i)
            if( i < 1 )
                i = 1;
            end
            if( i > obj.size() )
                i = obj.size();
            end
            uu = linspace(0,1,100)';
            if(i>1)
                hold on;
                u = obj.U{i-1};
                v = obj.V{i-1};
                vv = spline(u,v,uu);
                line2([uu vv],'LineStyle','--','Color','red');
            end
            if(i<obj.size())
                hold on;
                vv = spline(obj.U{i+1},obj.V{i+1},uu);
                line2([uu vv],'LineStyle','--','Color','blue');
            end
            hold on;
            vv = spline(obj.U{i},obj.V{i},uu);
            line2([uu vv],'LineStyle','-','Color','green','LineWidth',2);
            axis([0 1 0 1]);
        end
        
    end
    
end