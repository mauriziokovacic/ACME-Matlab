classdef ColorPicker < handle
    properties( Access = public, SetObservable )
        CData
    end
    
    properties( Access = private, Hidden = true )
        FigureHandle
        AxesHandle
        TriangleHandle
        CBuffer
        InterCatcher
        MouseHandler
        Camera
    end
    
    events
        EventColorPicked
    end
    
    methods( Access = public )
        function [obj] = ColorPicker(varargin)
            obj.FigureHandle = figure('Name','ColorPicker',...
                                      'NumberTitle','off',...
                                      'MenuBar', 'none',...
                                      'ToolBar','none',...
                                      'Resize','off',...
                                      'Position', [50 50 250 250]);
            obj.FigureHandle.WindowButtonMotionFcn = @(varargin) [];
            obj.AxesHandle = CreateAxes3D(obj.FigureHandle);
            
            [x,y,z] = sphere(64);
            t = surf2patch(x,y,z);
            P = t.vertices;
            T = t.faces;
            C = ones(size(P));%normal2color(P);
            
            obj.TriangleHandle = patch('Faces',T,...
                                       'Vertices',P,...
                                       'FaceColor','interp',...
                                       'FaceVertexCData',C,...
                                       'EdgeColor','none',...
                                       'FaceLighting','none',...
                                       'Parent',obj.AxesHandle);
            view(2);
            axis([min(P(:,1)) max(P(:,1)) min(P(:,2)) max(P(:,2))]);
            axis vis3d;

            hold on;
            P = equilateral_polygon(64);
            Pz = [P zeros(row(P),1)];
            Py = [P(:,1) zeros(row(P),1) P(:,2)];
            Px = [zeros(row(P),1) P];
            line3([Px;Px(1,:)],'LineWidth',2,'Color','r');
            line3([Py;Py(1,:)],'LineWidth',2,'Color','g');
            line3([Pz;Pz(1,:)],'LineWidth',2,'Color','b');
            
            text( 1.1,0,0,'+X');
            text(-1.1,0,0,'-X');
            text(0, 1.1,0,'+Y');
            text(0,-1.1,0,'-Y');
            text(0,0, 1.1,'+Z');
            text(0,0,-1.1,'-Z');
            
%             obj.CBuffer = ReadBufferColor(obj.FigureHandle);
            
            obj.InterCatcher = InteractionEventCatcher(obj.FigureHandle);
            obj.MouseHandler = MouseEventHandler(obj.InterCatcher);
            obj.Camera       = CameraObject(obj.AxesHandle);
            
            addlistener(obj.MouseHandler,'EventLeftGrab',@obj.EventMouseLeftGrab);
            addlistener(obj.MouseHandler,'EventRelease',@obj.EventMouseRelease);
        end
    end
    
    methods( Access = private, Hidden = true )
        function [CData] = fetchColorData(obj)
            CData        = [];
            currentPoint = obj.FigureHandle.Position(3:4)/2;
            windowSize   = obj.FigureHandle.Position(3:4);
            bufferSize   = [row(obj.CBuffer) col(obj.CBuffer)];
            i            = GetBufferDataIndex(windowSize,...
                                              currentPoint,...
                                              bufferSize );
            if( isempty(i) )
                return;
            end
            CData = color2double(reshape(obj.CBuffer(i(1),i(2),:),1,3));
        end
        
        function [obj] = EventMouseLeftGrab(obj,varargin)
            d = obj.Camera.ViewportDirection();
            obj.Camera.RotateCameraPosition(d(1),d(2));
        end
        
        function [obj] = EventMouseRelease(obj,varargin)
%             obj.CBuffer = ReadBufferColor(obj.FigureHandle);
%             obj.CData   = obj.fetchColorData();
            obj.CData = -obj.Camera.CameraDirection();
            if(~isempty(obj.CData))
                notify(obj,'EventColorPicked');
            end
        end
    end
end