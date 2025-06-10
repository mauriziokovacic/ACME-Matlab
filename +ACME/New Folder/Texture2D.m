classdef Texture2D < handle
    properties( Access = public, SetObservable )
        Data(:,:) double {mustBeFinite,mustBeNumeric,mustBeReal}
        Name(1,:) char = ''
    end
    
    properties( Access = private, Hidden = true )
        F
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = Texture2D(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter(parser,'Data',[], @(x) isnumeric(x));
            addParameter(parser,'Name','', @(x) isstring(x)||ischar(x));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function [tf] = isempty(obj)
            tf = isempty(obj.Data);
        end
        
        function [V] = fetch(obj,varargin)
            V = obj.F(varargin{:});
        end
        
        function reset(obj)
            obj.Data = [];
        end
        
        function [tf] = eq(A,B)
            u  = linspace(0,1,max(row(A.Data),row(B.Data)));
            v  = linspace(0,1,max(col(A.Data),col(B.Data)));
            tf = isempty(find(A.fetch({u,v})~=B.fetch({u,v}),1));
        end
        
        function [tf] = neq(A,B)
            tf = ~(A==B);
        end
    end
    
    methods
        function set.Data(obj,value)
            obj.Data = full(value);
            update_interpolant(obj);
        end
        
        function [h] = show(obj,varargin)
            h = mat2img(obj.fetch({linspace(0,1,512),linspace(0,1,512)}),varargin{:});
        end
    end
    
    methods( Access = protected )
        function update_interpolant(obj)
            if(isempty(obj))
                return;
            end
            [u,v] = ndgrid(linspace(0,1,row(obj.Data)),linspace(0,1,col(obj.Data)));
            obj.F = griddedInterpolant(u,v,obj.Data,'linear','nearest');
        end
    end
    
    methods( Access = public, Static = true )
        function [obj] = from_image(I,name)
            if(nargin<2)
                name = '';
            end
            if(isstring(I)||ischar(I))
                if(isempty(name))
                    [~,name] = fileparts(I);
                end
                I = imread(I);
                I = color2double(I);
            end
            if(isempty(name))
                name = 'Image';
            end
            obj = Texture2D.from_matrix(I,name);
        end
        
        function [obj] = from_matrix(M,name)
            if(nargin<2)
                name = '';
            end
            if( size(M,3)==3 )
                M = rgb2gray(M);
            end
            if(isempty(name))
                name = 'Matrix';
            end
            obj = Texture2D('Data',M,'Name',name);
        end
    end
end