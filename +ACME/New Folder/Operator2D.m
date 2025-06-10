classdef Operator2D < Texture2D
    methods( Access = public, Sealed = true )
        function [obj] = Operator2D(varargin)
            obj@Texture2D(varargin{:});
        end
    end
    
    methods
        function [obj] = plus(A,B)
            if(isa(A,'Operator2D')&&isnumber(B))
                obj = Operator2D('Data',A.Data+B,...
                               'Name',strcat(num2str(B),'+',A.Name));
                return
            end
            if(isnumber(A)&&isa(B,'Operator2D'))
                obj = plus(B,A);
                return
            end
            u  = linspace(0,1,max(row(A.Data),row(B.Data)));
            v  = linspace(0,1,max(col(A.Data),col(B.Data)));
            obj = Operator2D('Data',A.fetch({u,v})+B.fetch({u,v}),...
                           'Name',strcat(A.Name,'+',B.Name));
        end
        
        function [obj] = minus(A,B)
            if(isa(A,'Operator2D')&&isnumber(B))
                obj = Operator2D('Data',A.Data-B,...
                               'Name',strcat(A.Name,'-',num2str(B)));
                return
            end
            if(isnumber(A)&&isa(B,'Operator2D'))
                obj = Operator2D('Data',A-B.Data,...
                               'Name',strcat(num2str(A),'-',B.Name));
                return
            end
            u  = linspace(0,1,max(row(A.Data),row(B.Data)));
            v  = linspace(0,1,max(col(A.Data),col(B.Data)));
            obj = Operator2D('Data',A.fetch({u,v})-B.fetch({u,v}),...
                           'Name',strcat(A.Name,'-',B.Name));
        end
        
        function [obj] = uminus(A)
            obj = Operator2D('Data',-A.Data,...
                           'Name',strcat('-',A.Name));
        end
        
        function [obj] = mtimes(A,B)
            if(isa(A,'Operator2D')&&isnumber(B))
                obj = Operator2D('Data',A.Data*B,...
                               'Name',strcat(num2str(B),'*',A.Name));
                return
            end
            if(isnumber(A)&&isa(B,'Operator2D'))
                obj = B*A;
                return
            end
            u  = linspace(0,1,max(row(A.Data),row(B.Data)));
            v  = linspace(0,1,max(col(A.Data),col(B.Data)));
            obj = Operator2D('Data',A.fetch({u,v}).*B.fetch({u,v}),...
                           'Name',strcat(A.Name,'*',B.Name));
        end
        
        function viewer(obj)
            fig = figure('Name','Contact Plane Operator Flow','NumberTitle','off','IntegerHandle','off');
            n   = 1000;
            x   = linspace(0,1,n)';
            y   = obj.fetch(zeros(n,1),x);
            h   = plot(x,y);
            axis([0 1 minimum(obj.Data) maximum(obj.Data)]);


            slider = uicontrol( fig,...
                                'Style', 'slider',...
                                'Position', [100, 10, 200, 20],...
                                'Min', 0,...
                                'Max', 1,...
                                'SliderStep', [0.001 0.1],...
                                'Value', 0);
            addlistener( slider, 'ContinuousValueChange',...
                        @(object,event) handler(slider.Value) );

            function handler(v)
                delete(h);
                y   = obj.fetch(repmat(v,n,1),x);
                h = plot(x,y);
                axis([0 1 minimum(obj.Data) maximum(obj.Data)]);
            end

        end
    end
end
