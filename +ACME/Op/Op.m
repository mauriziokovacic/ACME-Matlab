classdef Op < handle
    properties
        U
        V
        dU
        dV
        Scale
        Name
    end
    
    methods
        function obj = Op(varargin)
            obj.U = [];
            obj.V = [];
            obj.Scale = 1;
            obj.Name = 'default';
            if( nargin >= 3 )
                Name = varargin{3};
            end
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
                obj.U = repmat(linspace(0,1,n)',1,n);
                obj.V = repmat(0.5,n,n);
            else
                obj.U = repmat(linspace(0,1,n(1))',1,n(2));
                obj.V = repmat(0.5,n(1),n(2));
            end
            obj.Scale = s;
        end
        
        function s = size(obj)
            s = size(obj.U);
        end
        
        
        function show(obj,ax,i)
            if( i < 1 )
                i = 1;
            end
            if( i > obj.size() )
                i = obj.size();
            end
            uu = linspace(0,1,100)';
            if(i>1)
%                 hold on;
                vv = spline(obj.U(:,i-1),obj.V(:,i-1),uu);
                vv( vv < 0 ) = 0;
                vv( vv > 1 ) = 1;
                line(ax,uu,vv,'LineStyle','--','Color','red');
            end
            if(i<size(obj.U,2))
%                 hold on;
                vv = spline(obj.U(:,i+1),obj.V(:,i+1),uu);
                vv( vv < 0 ) = 0;
                vv( vv > 1 ) = 1;
                line(ax,uu,vv,'LineStyle','--','Color','blue');
            end
%             hold on;
            vv = spline(obj.U(:,i),obj.V(:,i),uu);
            vv( vv < 0 ) = 0;
            vv( vv > 1 ) = 1;
            line(ax,uu, vv,'LineStyle','-','Color','green','LineWidth',2);
%             axis(ax,[0 1 0 1]);
        end
        
        
        function preview( obj, ax, resolution, method )
            I = obj.op2img(resolution,method);
            imshow(I,'Parent',ax);
        end
        
        function I = op2img( obj, resolution, method )
            if( numel( resolution) == 1 )
                resolution = [resolution resolution];
            end
            s = obj.size();
            n = s(1);
            m = s(2);
            [X,Y] = meshgrid(linspace(1,0,n),linspace(0,1,m));
            [Xq,Yq] = meshgrid(linspace(0,1,resolution(1)),linspace(0,1,resolution(2)));
            I = interp2(X,Y,obj.V',Xq,Yq,method);
        end
        
        
        function store(obj,filename)
            fileID = fopen(filename,'w');
            fwrite(fileID,obj.size(),'uint32');
            fwrite(fileID,obj.Scale,'uint32');
            fwrite(fileID,obj.U,'double');
            fwrite(fileID,obj.V,'double');
            fclose(fileID);
        end
        
        function load(obj,filename)
            fileID    = fopen(filename,'r');
            n         = fread(fileID,[1 2],'uint32');
            obj.Scale = fread(fileID,1,'uint32');
            obj.U     = fread(fileID,n,'double');
            obj.V     = fread(fileID,n,'double');
            fclose(fileID);
        end
        
        function obj = fromHeightFieldImage( obj, filename )
            Img = imread( filename );
            if( numel( size(Img) ) == 3 )
                Img = rgb2gray(Img);
            end
            Img = Img(1:(end/2),:);
            Img = imresize(Img,[size(Img,1), size(Img,1)]);
            Img = imresize(Img,[8 8]);
            n = size(Img);
            obj.U = repmat(linspace(0,1,n(1)/2)',1,n(2));
            obj.V = rot90((double(Img)/255));
            obj.V = obj.V(1:end/2,:);
            obj.Scale = 1;
            obj.Name  = 'file';
        end
        
    end
    
end