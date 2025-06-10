classdef CPSOperator
    
    properties
        Filename
        Resolution
        Bulge
        Gx
        Gy
    end
    
    methods
        function obj = CPSOperator( filename )
            if( nargin ~= 0 )
                [ obj.Filename, ...
                  obj.Resolution, ...
                  obj.Bulge ] = CPSOperatorLoader( filename );
            else
                obj.Filename   = 'default';
                obj.Bulge = [ 0     0     0     0    0     0    0     0    0;... % dt==d0
                              0     0     0     0    0     0    0.1   0.4  0.9;...
                              0     0     0.05  0.1  0.1   0.2  0.3   0.7  1;...
                              0     0.05  0.1   0.2  0.1   0.1  0.2   0.6  0.9;...
                              0.1   0.1   0.1   0.1  0.1   0.05 0.15  0    0;... % dt=0
                              0.01  0.01  0.01  0.01 0.05 -0.1 -0.1  -0.1 -0.1;...
                             -0.1  -0.1  -0.1  -0.1  0     0    0     0    0;...
                              0     0     0     0    0     0    0     0    0;...
                              0     0     0     0    0     0    0     0    0];   % dt=-d0
%                 obj.Bulge = imresize(obj.Bulge,[512,512],'cubic');
                obj.Resolution = size(obj.Bulge);
                obj = obj.computeGradient();
            end
        end
        
        function obj = computeGradient( obj )
            [obj.Gx, obj.Gy] = imgradientxy(obj.Bulge);
            obj.Resolution = size(obj.Bulge);
            obj.Gx = obj.Gx./(1/obj.Resolution(1));
            obj.Gy = obj.Gy./(1/obj.Resolution(2));
            obj.Gx( ~isfinite(obj.Gx) ) = 0;
            obj.Gy( ~isfinite(obj.Gy) ) = 0;
        end
        
        function obj = fromMatrix( obj, M )
            obj.Filename   = 'from_matrix';
            obj.Bulge      = M;
            obj.Resolution = size(obj.Bulge);
            obj = obj.computeGradient();
        end
        
        function obj = fromImages( obj, path, depth )
            obj.Filename = 'from_images';
            if ( nargin < 3 )
                depth = 0.5;
            end
            if( depth <= 0 || depth > 1 )
                depth = 0.5;
            end
            files = dir( path );
            n = numel(files);
            obj.Bulge = [];
            for i = 1 : n
                name = [files(i).folder,'/',files(i).name];
                Img = imread( name );
                if( numel( size(Img) ) == 3 )
                    Img = rgb2gray(Img);
                end
                if( ~islogical(Img) )
                    Img = imbinarize(Img,'global');
                end
                v = sum( Img .* linspace(1,-1,size(Img,2))', 1 );
                s = sum( Img, 1 ); 
                obj.Bulge = [obj.Bulge;v./s];
            end
            obj.Bulge = [obj.Bulge;zeros(floor(n/depth)-n,size(obj.Bulge,2))];
            if( size(obj.Bulge,1) < size(obj.Bulge,2) )
                obj.Bulge = imresize(obj.Bulge,[size(obj.Bulge,1) size(obj.Bulge,1)]);
            end
            if( size(obj.Bulge,2) < size(obj.Bulge,1) )
                obj.Bulge = imresize(obj.Bulge,[size(obj.Bulge,2) size(obj.Bulge,2)]);
            end
            obj.Bulge( abs(obj.Bulge)<0.0001 ) = 0;
            
            for i = 1 : size(obj.Bulge,2)
                t = (i-1)/(size(obj.Bulge,2)-1);
                m = (((1-t).*-0.01)-t).^2;
                M = (((1-t).*0.01)+t).^2;
                t = clamp((obj.Bulge(:,i)-m)./(M-m),0,1);
                v = t.*M+(1-t).*m;
                obj.Bulge(:,i) = v;
            end
            
            
            obj.Resolution = size(obj.Bulge);
            obj = obj.computeGradient();
        end
        
        function obj = fromHeightFieldImage( obj, filename )
            obj.Filename = 'from_height';
            Img = imread( filename );
            if( numel( size(Img) ) == 3 )
                Img = rgb2gray(Img);
            end
            obj.Bulge = (double(Img) - (255*0.5)) / (255*0.5);
            obj.Resolution = size(obj.Bulge);
            obj = obj.computeGradient();
        end
        
        function toImages( obj, path, resolution )
            I = obj.op2img(resolution);
            for i = 1 : size(I,1)
                Img = squeeze(I(i,:,:));
                imwrite(Img,[path,num2str(i-1),'.png'],'png');
            end
        end
        
        function toData( obj, filename )
%             fileID = fopen([filename,'_F.dat'],'w');
%             fwrite(fileID,obj.Bulge','float');
%             fclose(fileID);
%             fileID = fopen([filename,'_Gx.dat'],'w');
%             fwrite(fileID,obj.Gx','float');
%             fclose(fileID);
%             fileID = fopen([filename,'_Gy.dat'],'w');
%             fwrite(fileID,obj.Gy','float');
%             fclose(fileID);
            matrix2file([filename,'_F'],obj.Bulge);
            matrix2file([filename,'_Gx'],obj.Bulge);
            matrix2file([filename,'_Gy'],obj.Bulge);
        end
        
        function I = op2img( obj, resolution )
            I = zeros(obj.Resolution(1),resolution,resolution);
            I = logical(I);
            for k = 1 : size(I,1)
                v = interp1(linspace(0,1,obj.Resolution(2)),...
                            obj.Bulge(k,:),...
                            linspace(0,1,resolution))';
                v = floor((1-(clamp(v,-1,1)+1)*0.5)*(resolution-1))+1;
                for i = 1 : resolution
                    I(k,v(i),i) = true;
                end
            end
        end
        
        function [f] = fetch( obj, I, fD )
            f = interp2(linspace(0,1,obj.Resolution(1)),...
                        linspace(0,1,obj.Resolution(2)),...
                        obj.Bulge,I,fD);
        end
        
    end
    
end
