classdef Camera < handle
    properties
        CameraPosition    % 3D vector
        CameraTarget      % 3D vector
        CameraUpVector    % 3D vector
        CameraViewAngle   % Scalar in range [0,180)
        Projection        % perspective, orthographic
        Clipping          % on, off
        ClippingStyle     % 3dbox, rectangle
        XLim              % limits [min , max]
        YLim              % limits [min , max]
        ZLim              % limits [min , max]
        Path              % Path
        PathTime          % Path time
    end
    
    methods( Access = public )
        function obj = Camera(varargin)
            if( nargin >= 1 )
                obj.CameraPosition = varargin{1};
            else
                obj.CameraPosition = [0 0 1];
            end
            if( nargin >= 2 )
                obj.CameraTarget = varargin{2};
            else
                obj.CameraTarget = [0 0 0];
            end
            if( nargin >= 3 )
                obj.CameraUpVector = varargin{3};
            else
                obj.CameraUpVector = [0 1 0];
            end
            if( nargin >= 4 )
                obj.CameraViewAngle = varargin{4};
            else
                obj.CameraViewAngle = 6.6086;
            end
            if( nargin >= 5 )
                obj.Projection = varargin{5};
            else
                obj.Projection = 'perspective';
            end
            if( nargin >= 6 )
                obj.Clipping = varargin{6};
            else
                obj.Clipping = 'off';
            end
            if( nargin >= 7 )
                obj.ClippingStyle = varargin{7};
            else
                obj.ClippingStyle = 'rectangle';
            end
            obj.Path = size(obj.CameraPosition,1);
            if( nargin >= 8 )
                obj.PathTime = varargin{8};
            else
                obj.PathTime = [];
            end
            obj.XLim = repmat([0 1],obj.Path,1);
            obj.YLim = repmat([0 1],obj.Path,1);
            obj.ZLim = repmat([0 1],obj.Path,1);
        end
        
        [obj] = setPosition(obj,value);
        [obj] = setTarget(obj,value);
        [obj] = track(obj,P);
        [obj] = setUpVector(obj,value);
        [obj] = setViewAngle(obj,value);
        [obj] = setPerspective(obj);
        [obj] = setOrthographic(obj);
        [tf]  = isPerspective(obj);
        [tf]  = isOrthographic(obj);
        [obj] = toggleClipping(obj,tf);
        [obj] = enableClipping(obj);
        [obj] = disableClipping(obj);
        [obj] = setClippingStyle(obj,type);
        [obj] = setXLim(obj,lim);
        [obj] = setYLim(obj,lim);
        [obj] = setZLim(obj,lim);
        [tf]  = hasPath(obj);
        [obj] = set_path_to(obj,t);
        [tf]  = hasPathTime(obj);
        [obj] = set_pathtime_to(obj,t);
        
        [obj] = load(obj,filename);
        [obj] = save(obj,filename);
        
        [fig] = apply_to_figure(obj,fig,t);
        [ax]  = apply_to_axes(obj,ax,t);
        
        [obj] = set_from(obj,h);
        [obj] = register_position(obj,h);
        [obj] = register_target(obj,h);
        [obj] = register_upvector(obj,h);
        [obj] = register_viewangle(obj,h);
        [obj] = register_xlim(obj,h);
        [obj] = register_ylim(obj,h);
        [obj] = register_zlim(obj,h);
        [obj] = register_camera(obj,h);
                
    end
    
    methods(Access = private)
        [NameArray,ValueArray] = getData(obj,t);
        [P,T,U,A,J,C,S,X,Y,Z] = fetchData(obj,t);
    end
    
    methods(Static)
        function obj = load_from(filename)
            formatP = 'p %f %f %f\n';
            formatT = 't %f %f %f\n';
            formatU = 'u %f %f %f\n';
            formatA = 'a %f\n';
            formatJ = 'j %s\n';
            formatC = 'c %s\n';
            formatS = 's %s\n';
            formatX = 'x %f %f\n';
            formatY = 'y %f %f\n';
            formatZ = 'z %f %f\n';
            formatR = 'r %f\n';
            fileID = fopen(strcat(filename,'.cam'),'r');
            obj = Camera();
            obj.CameraPosition  = fscanf( fileID, formatP, [3 Inf] )';
            obj.CameraTarget    = fscanf( fileID, formatT, [3 Inf] )';
            obj.CameraUpVector  = fscanf( fileID, formatU, [3 Inf] )';
            obj.CameraViewAngle = fscanf( fileID, formatA, [1 Inf] )';
            obj.Projection      = textscan( fileID, formatJ );
            obj.Clipping        = textscan( fileID, formatC );
            obj.ClippingStyle   = textscan( fileID, formatS );
            obj.XLim            = fscanf( fileID, formatX, [2 Inf] )';
            obj.YLim            = fscanf( fileID, formatY, [2 Inf] )';
            obj.ZLim            = fscanf( fileID, formatZ, [2 Inf] )';
            obj.PathTime        = fscanf( fileID, formatR, [1 Inf] )';
            fclose(fileID);
        end
        
        function save_to(obj,filename)
            formatP = 'p %f %f %f\n';
            formatT = 't %f %f %f\n';
            formatU = 'u %f %f %f\n';
            formatA = 'a %f\n';
            formatJ = 'j %s\n';
            formatC = 'c %s\n';
            formatS = 's %s\n';
            formatX = 'x %f %f\n';
            formatY = 'y %f %f\n';
            formatZ = 'z %f %f\n';
            formatR = 'r %f\n';
            fileID = fopen(strcat(filename,'.cam'),'w');
            fprintf( fileID, formatP, obj.CameraPosition' );
            fprintf( fileID, formatT, obj.CameraTarget' );
            fprintf( fileID, formatU, obj.CameraUpVector' );
            fprintf( fileID, formatA, obj.CameraViewAngle' );
            fprintf( fileID, formatJ, obj.Projection' );
            fprintf( fileID, formatC, obj.Clipping' );
            fprintf( fileID, formatS, obj.ClippingStyle' );
            fprintf( fileID, formatX, obj.XLim' );
            fprintf( fileID, formatY, obj.YLim' );
            fprintf( fileID, formatZ, obj.ZLim' );
            fprintf( fileID, formatR, obj.PathTime' );
            fclose(fileID);
        end
    end
end