classdef ContactProxy < dynamicprops
    properties( Access = public, SetObservable )
        Point(:,:,3)  {mustBeFinite, mustBeReal}
        Normal(:,:,3) {mustBeFinite, mustBeReal}
        Weight(:,:,:) {mustBeFinite, mustBeReal}
        Value(:,:)    {mustBeFinite, mustBeReal}
        Name(1,:)  char = ''
    end
    
    properties( Access = private, Hidden = true )
        Gpoint
        Gnormal
        Gweight
        Gvalue
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = ContactProxy(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter(parser,'Point',zeros(3,3,3), @(x) isnumeric(x));
            addParameter(parser,'Normal',zeros(3,3,3), @(x) isnumeric(x));
            addParameter(parser,'Weight',zeros(3), @(x) isnumeric(x));
            addParameter(parser,'Value',zeros(3), @(x) isnumeric(x));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function [P] = fetchPoint(obj, u, v, bulk)
            if( nargin < 4 )
                bulk = false;
            end
            if( bulk )
                P = reshape(obj.Gpoint({u,v,1:size(obj.Point,3)}),[],size(obj.Point,3));
            else
                if( numel(v)==1 )
                    v = repmat(v,numel(u),1);
                end
                if( numel(u)==1 )
                    u = repmat(u,numel(v),1);
                end
                P = cell2mat(arrayfun(@(uu,vv) reshape(obj.Gpoint({uu,vv,1:size(obj.Point,3)}),1,size(obj.Point,3)),...
                                      u, v, 'UniformOutput', false));
            end
        end
        
        function [N] = fetchNormal(obj, u, v, bulk)
            if( nargin < 4 )
                bulk = false;
            end
            if( bulk )
                N = reshape(obj.Gnormal({u,v,1:size(obj.Normal,3)}),[],size(obj.Normal,3));
            else
                if( numel(v)==1 )
                    v = repmat(v,numel(u),1);
                end
                if( numel(u)==1 )
                    u = repmat(u,numel(v),1);
                end
                N = cell2mat(arrayfun(@(uu,vv) reshape(obj.Gnormal({uu,vv,1:size(obj.Normal,3)}),1,size(obj.Normal,3)),...
                                      u, v, 'UniformOutput', false));
            end
        end
        
        function [W] = fetchWeight(obj, u, v, bulk)
            if( nargin < 4 )
                bulk = false;
            end
            if( bulk )
                W = reshape(obj.Gweight({u,v,1:size(obj.Weight,3)}),[],size(obj.Weight,3));
            else
                if( numel(v)==1 )
                    v = repmat(v,numel(u),1);
                end
                if( numel(u)==1 )
                    u = repmat(u,numel(v),1);
                end
                W = cell2mat(arrayfun(@(uu,vv) reshape(obj.Gweight({uu,vv,1:size(obj.Weight,3)}),1,size(obj.Weight,3)),...
                                      u, v, 'UniformOutput', false));
            end
            W = sparse(W);
            W(W<0.0001) = 0;
        end
        
        function [V] = fetchValue(obj, u, v, bulk)
            if( nargin < 4 )
                bulk = false;
            end
            if( bulk )
                V = reshape(obj.Gvalue({u,v}),[],1);
            else
                if( numel(v)==1 )
                    v = repmat(v,numel(u),1);
                end
                if( numel(u)==1 )
                    u = repmat(u,numel(v),1);
                end
                V = cell2mat(arrayfun(@(uu,vv) reshape(obj.Gvalue({uu,vv}),1,1),...
                                      u, v, 'UniformOutput', false));
            end
        end
        
        function [P] = fetchFoldPoint(obj, u, v, bulk)
            if(nargin < 4)
                bulk = false;
            end
            P = fetchPoint(obj, zeros(size(v)), v, bulk);
        end
        
        function [N] = fetchFoldDirection(obj, u, v, bulk)
            if(nargin < 4)
                bulk = false;
            end
            Pi = fetchPoint(obj, u,v,bulk);
            Pj = fetchPoint(obj,-u,v,bulk);
            N  = Pi-Pj;
            d  = vecnorm(N,2,2);
            i = find(d>0.0001);
            N(i,:) = normr(N(i,:));
        end
        
        function [W] = fetchFoldWeight(obj, u, v, bulk)
            if(nargin < 4)
                bulk = false;
            end
            W = fetchWeight(obj,zeros(size(v)),v,bulk);
        end
        
        function [P,N,W,V,P_,N_,W_] = fetch(obj, u, v, bulk)
            if( nargin < 4 )
                bulk = false;
            end
            P  = fetchPoint(obj,u,v,bulk);
            N  = fetchNormal(obj,u,v,bulk);
            W  = fetchWeight(obj,u,v,bulk);
            V  = fetchValue(obj,u,v,bulk);
            P_ = fetchFoldPoint(obj,u,v,bulk);
            N_ = fetchFoldDirection(obj,u,v,bulk);
            W_ = fetchFoldWeight(obj,u,v,bulk);
        end
        
        function [P,T,N,W,V,P_,N_,W_] = proxy2mesh(obj, u, v)
            if( nargin < 3 )
                v = linspace(0,1,50);
            end
            if( nargin < 2 )
                u = linspace(-1,1,50);
            end
            P = obj.Gpoint({u,v,1:size(obj.Point,3)});
            N = obj.Gnormal({u,v,1:size(obj.Normal,3)});
            W = obj.Gweight({u,v,1:size(obj.Weight,3)});
            V = obj.Gvalue({u,v});
            [~,T,N] = grid2mesh(P,N);
            [~,~,W] = grid2mesh(P,W);
            [P,~,V] = grid2mesh(P,V);
        end
        
        function show(obj,varargin)
            [P,T,N] = proxy2mesh(obj);
            display_mesh(P,N,T,[],'wired',varargin{:});
        end
        
        function updateProp(obj, propName)
            u = linspace(-1,1,row(obj.(propName)));
            v = linspace( 0,1,col(obj.(propName)));
            w = 1:size(obj.(propName),3);
            d = obj.(propName);
            [u,v,d] = padinterp2(u,v,d,3);
            obj.(['G',lower(propName)]) = griddedInterpolant({u,v,w},...
                                                             d,...
                                                             'linear','nearest');
        end
        
        function updatePoint(obj)
            updateProp(obj,'Point');
        end
        
        function updateNormal(obj)
            updateProp(obj,'Normal');
        end
        
        function updateWeight(obj)
            updateProp(obj,'Weight');
        end
        
        function updateValue(obj)
%             updateProp(obj,'Value');
            u = linspace(-1,1,row(obj.Value));
            v = linspace( 0,1,col(obj.Value));
            d = obj.Value;
            [u,v,d] = padinterp2(u,v,d,3);
            obj.Gvalue = griddedInterpolant({u,v},...
                                            d,...
                                            'linear','nearest');
        end
        
        
        
        function update(obj)
            obj.updatePoint();
            obj.updateNormal();
            obj.updateWeight();
            obj.updateValue();
        end
        
        function [C] = extract_isocurve(obj,value,n,type)
            if(nargin<4)
                type = 'u';
            end
            switch lower(type)
                case 'v'
                    P = obj.fetch(linspace(-1,1,n)',value,true);
                    E = curveEdge(n,false);
                case 'u'
                    P = obj.fetch(value,linspace(0,1,n),true);
                    E = curveEdge(n,true);
                otherwise
                    error('Unknown type.')
            end
            C = BaseCurve('Point',P,'Edge',E);
        end
    end
end