classdef CurveSketcherTool < ModelViewerTool
    properties( SetObservable )
        SketchMode
    end
    
    properties( Access = private )
        Buffer
        SketchTool
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = CurveSketcherTool(varargin)
            obj@ModelViewerTool(varargin{:});
            setTitle(obj,'Curve Painter Tool');
            obj.Buffer     = PainterBuffer(obj.FigureHandle);
            obj.SketchTool = SketchTool(obj.FigureHandle);
            obj.SketchMode = false;
            setConsoleText(obj,['\textbf{Sketch Mode}: ',bool2status(obj.SketchMode),'\quad \textit{(press s to change)}']);
        end
        
        function [tf] = isSketchModeActive(obj)
            tf = obj.SketchMode;
        end
        
        function toggleSketchMode(obj,status)
            obj.SketchMode = status;
        end
        
        function enableSketchMode(obj)
            toggleSketchMode(obj,true);
        end
        
        function disableSketchMode(obj)
            toggleSketchMode(obj,false);
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            registerProps@ModelViewerTool(obj);
            addProps(obj,'Curve');
        end
    end
    
    methods( Access = public )
        function EventKeyPress(obj,~,event)
            switch event.Key
                case 's'
                    toggleSketchMode(obj,~isSketchModeActive(obj));
                    if(isSketchModeActive(obj))
                        disableConsole(obj);
                        obj.Buffer.rebuildBuffers();
                        enableConsole(obj);
                    end
                    setConsoleText(obj,['\textbf{Sketch Mode}: ',bool2status(obj.SketchMode),'\quad \textit{(press s to change)}']);
            end
        end
        
        function EventMouseLeftClick(obj,source,event)
            if(isSketchModeActive(obj))
                obj.SketchTool.addPoint(event.Position);
            else
                EventMouseLeftClick@ModelViewerTool(obj,source,event)
            end
        end
        
        function EventMouseLeftGrab(obj,source,event)
            if(isSketchModeActive(obj))
                obj.SketchTool.addPoint(event.Position);
            else
                EventMouseLeftGrab@ModelViewerTool(obj,source,event)
            end
        end
        
        function EventMouseLeftGrabRelease(obj,~,~)
            if(isSketchModeActive(obj))
                i = obj.Buffer.computeBufferIndex(obj.SketchTool.toPixel());
                P = readBufferPosition(obj.Buffer,i);
                if(isempty(P))
                    obj.SketchTool.reset();
                    return;
                end
                n = readBufferNormal(obj.Buffer,i);
                %%%%%%%%%%%%% FITTING %%%%%%%%%%%%%
                P = curveFit(P,'Fitting','poly','Degree',min(row(P),10));
                n = curveFit(n,'Fitting','poly','Degree',min(row(n),10));
%                 t = linspace(0,1,row(i))';
%                 d = min(row(i),10);
%                 p = [polyfit(t,i(:,1),d);polyfit(t,i(:,2),d);polyfit(t,i(:,3),d)];
%                 i = [polyval(p(1,:),t) polyval(p(2,:),t) polyval(p(3,:),t)];
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                C = obj.Parent.Curve;
                C = [C;{P,n}];
                display_curve(P,[(1:row(P)-1)' (2:row(P))'],'EdgeColor','r','HitTest','off','PickableParts','none');
                setProps(obj,'Curve',C);
                obj.SketchTool.reset();
            end
        end
        
        function EventMouseScroll(obj,source,event)
            if(~isSketchModeActive(obj))
                EventMouseScroll@ModelViewerTool(obj,source,event)
            end
        end
    end
    
    methods( Static )
        function [obj] = standAlone(varargin)
            parser = inputParser;
            addRequired( parser, 'Mesh', @(data) isa(data,'AbstractMesh'));
            parse(parser,varargin{:});
            h   = SharedDataSystem('Mesh',parser.Results.Mesh);
            obj = CurveSketcherTool(h);
        end
    end
end