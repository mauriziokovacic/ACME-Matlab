classdef PainterTool < ModelViewerTool
    properties( Access = public, SetObservable )
        PaintMode
    end
    
    properties( Access = protected )
        Buffer
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = PainterTool(varargin)
            obj@ModelViewerTool(varargin{:});
            setTitle(obj,'Painter Tool');
            obj.Buffer    = PainterBuffer(obj.FigureHandle);
            obj.PaintMode = false;
            setConsoleText(obj,['\textbf{Paint Mode}: ',bool2status(obj.PaintMode),'\quad \textit{(press p to change)}']);
        end
        
        function [tf] = isPaintModeActive(obj)
            tf = obj.PaintMode;
        end
        
        function togglePaintMode(obj,status)
            obj.PaintMode = status;
        end
        
        function enablePaintMode(obj)
            togglePaintMode(obj,true);
        end
        
        function disablePaintMode(obj)
            togglePaintMode(obj,false);
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            registerProps@ModelViewerTool(obj);
        end
    end
    
    methods( Access = public )
        function EventKeyPress(obj,source,event)
            switch event.Key
                case 'p'
                    togglePaintMode(obj,~isPaintModeActive(obj));
                    if(isPaintModeActive(obj))
                        disableConsole(obj);
                        obj.Buffer.rebuildBuffers();
                        enableConsole(obj);
                        createSelectionInterface(obj);
                    else
                        removeSelectionInterface(obj);
                    end
                    setConsoleText(obj,['\textbf{Paint Mode}: ',bool2status(obj.PaintMode),'\quad \textit{(press p to change)}']);
            end
        end
        
        function EventMouseMove(obj,source,event)
            if(isPaintModeActive(obj))
                mouseMoveRoutine(obj,source,event);
                selectionInterfaceUpdate(obj)
            else
                EventMouseMove@ModelViewerTool(obj,source,event)
            end
        end
        
        function EventMouseLeftClick(obj,source,event)
            if(isPaintModeActive(obj))
                mouseLeftClickRoutine(obj,source,event);
                selectionInterfaceUpdate(obj)
            else
                EventMouseLeftClick@ModelViewerTool(obj,source,event)
            end
        end
        
        function EventMouseLeftGrab(obj,source,event)
            if(isPaintModeActive(obj))
                mouseLeftGrabRoutine(obj,source,event);
            else
                EventMouseLeftGrab@ModelViewerTool(obj,source,event)
            end
        end
        
        function EventMouseLeftGrabRelease(obj,source,event)
            if(isPaintModeActive(obj))
                mouseLeftGrabReleaseRoutine(obj,source,event);
                selectionInterfaceUpdate(obj)
            else
                EventMouseLeftGrabRelease@ModelViewerTool(obj,source,event)
            end
        end
        
        function EventMouseScroll(obj,source,event)
            if(isPaintModeActive(obj))
                mouseScrollRoutine(obj,source,event);
                selectionInterfaceUpdate(obj)
            else
                EventMouseScroll@ModelViewerTool(obj,source,event)
            end
        end
    end
    
    methods( Access = protected, Abstract )
        createSelectionInterface(obj)
        removeSelectionInterface(obj);
        selectionInterfaceUpdate(obj)
        mouseMoveRoutine(obj,source,event)
        mouseLeftClickRoutine(obj,source,event)
        mouseLeftGrabRoutine(obj,source,event)
        mouseLeftGrabReleaseRoutine(obj,source,event)
        mouseScrollRoutine(obj,source,event);
    end
end