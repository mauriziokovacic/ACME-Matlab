classdef AbstractPainterPlugin < AbstractPickerPlugin
    properties( Access = public )
        Brush
    end
    
    properties( Access = protected )
        MBuffer
        PBuffer
        
        Transform
        SelectionSphere
        
        Stroke
    end
    
    properties( Access = protected )
        Guide = [];
        GuideVisible = false;
    end
    
    events
        UpdateSelectionSphere
    end
    
    methods( Access = public )
        function [obj] = AbstractPainterPlugin(varargin)
            obj@AbstractPickerPlugin(varargin{:});
%             addlistener(obj.Parent,'ViewerSizeChanged',@(varargin) obj.rebuildBuffers());
            addlistener(obj,'StandbyEnabled', @(varargin) obj.standbyPainterData(true));
            addlistener(obj,'StandbyDisabled',@(varargin) obj.standbyPainterData(false));
            addlistener(obj,'UpdateSelectionSphere',@(varargin) obj.selectionInterfaceUpdate());
        end
        
        function [obj] = EventMouseLeftClick(obj,source,event)
            if(any(strcmpi(event.Modifier,'shift')))
                P = (event.Position-1)./(obj.Parent.FigureHandle.Position(3:4)-1);
                obj.Stroke = annotation('line',...
                                        repmat(P(1),1,2),...
                                        repmat(P(2),1,2),...
                                        'LineWidth',2,'Color','r',...
                                        'Units','pixel');
            end
        end
        
        function [obj] = EventMouseLeftGrab(obj,source,event)
            if(any(strcmpi(event.Modifier,'shift')))
                obj.Stroke.X(2) = event.Position(1);
                obj.Stroke.Y(2) = event.Position(2);
            else
                obj.BrushVertex();
            end
        end
        
        function [obj] = EventKeyRelease(obj,source,event)
            if( strcmpi(event.Key,'shift') )
                delete(obj.Stroke);
                obj.Stroke = [];
            end
        end
        
        function [obj] = EventMouseLeftRelease(obj,source,event)
            if(any(strcmpi(event.Modifier,'shift')))
                pixel       = bresenham(obj.Stroke.X,obj.Stroke.Y);
                bufferIndex = obj.computeBufferIndex(pixel,...
                                                     obj.Parent.FigureHandle.Position(3:4));
                obj.Brush.Position = obj.readBufferPoint(bufferIndex);
                obj.BrushVertex();
                delete(obj.Stroke);
                obj.Stroke = [];
            end
        end
        
        function [obj] = EventMouseMove(obj,source,event)
            bufferIndex = obj.computeBufferIndex(event.Position,...
                                                 obj.Parent.FigureHandle.Position(3:4));
            obj.Brush.Position = obj.readBufferPoint(bufferIndex);
            obj.selectionInterfaceUpdate();
        end
        
        function [obj] = EventMouseScroll(obj,source,event)
            s = 1-event.Data.VerticalScrollCount*0.1;
            if(any(strcmpi(event.Modifier,'control')))
                obj.Brush.setStrenght(obj.Brush.Strenght*s);
            else
                if( s <= 0 )
                    return;
                end
                obj.Brush.setRadius(obj.Brush.Radius*s);
            end
            obj.selectionInterfaceUpdate();
        end
        
    end
    
    methods( Abstract )
        BrushVertex(obj,P)
    end
    
    methods( Access = protected )
        function [menu] = buildStandardMenu(obj,program,painterName)
            menu  = program.getMenu('Painters');
            menu  = uimenu(menu,'Text',painterName);
            mitem = uimenu(menu,'Text','Import Data');
            uimenu(mitem,'Text','From Workspace...','MenuSelectedFcn',@obj.importFromWorkspace);
            uimenu(mitem,'Text','From file...','MenuSelectedFcn',@obj.importFromFile);
            mitem = uimenu(menu,'Text','Export Data');
            uimenu(mitem,'Text','To Workspace...','MenuSelectedFcn',@obj.exportToWorkspace);
            uimenu(mitem,'Text','To file...','MenuSelectedFcn',@obj.exportToFile);
            mitem = uimenu(menu,'Text','Enable','Separator','on');
            guide = uimenu(menu,'Text','LoadGuide','Enable','off','MenuSelectedFcn',@obj.loadGuide);
            mitem.MenuSelectedFcn = ...
            @(h,e)(cellfun(@(x)feval(x,h,e), ...
                          {@obj.sendActivationRequest, ...
                           @(varargin)set(mitem,'Checked',bool2str(~str2bool(mitem.Checked))), ...
                           @(varargin)set(mitem,'Text',bool2status(~status2bool(mitem.Text))),...
                           @(varargin)set(guide,'Enable',bool2str(~status2bool(mitem.Text)))},...
                           'UniformOutput',false));
        end
        
        function importFromWorkspace(obj,varargin)
        end
        
        function importFromFile(obj,varargin)
        end
        
        function exportToWorkspace(obj,varargin)
        end
        
        function exportToFile(obj,varargin)
        end
        
        function loadGuide(obj,varargin)
            delete(obj.Guide);
            obj.Guide = evalin('base','C');
            obj.Guide = obj.Guide.show([],'EdgeColor','r',...
                                       'HandleVisibility','off',...
                                       'HitTest','off',...
                                       'PickableParts','none');
            obj.GuideVisible = true;
        end
        
        function [obj] = rebuildBuffers(obj)
            obj.MBuffer = ReadBufferMask(obj.Parent.FigureHandle);
            obj.PBuffer = ReadBufferPosition(obj.Parent.FigureHandle,...
                                             obj.MinPoint,...
                                             obj.MaxPoint);
        end
        
        function [obj] = buildPainterData(obj)
            obj.rebuildBuffers();
            ax = get_axes(obj.Parent.FigureHandle);
            ax.XLimMode = 'manual';
            ax.YLimMode = 'manual';
            ax.ZLimMode = 'manual';
            obj.buildSelectionInterface();
        end
        
        function [obj] = standbyPainterData(obj,status)
            if(~status)
                if(isempty(obj.MBuffer))
                    obj.rebuildBuffers();
                end
            else
                obj.MBuffer = [];
                obj.PBuffer = [];
            end
            obj.selectionInterfaceStandby(status);
        end
        
        function [obj] = destroyPainterData(obj)
            obj.MBuffer = [];
            obj.PBuffer = [];
            ax = get_axes(obj.Parent.FigureHandle);
            ax.XLimMode = 'auto';
            ax.YLimMode = 'auto';
            ax.ZLimMode = 'auto';
            delete(obj.Transform);
            delete(obj.SelectionSphere);
            delete(obj.Guide);
            obj.Transform       = [];
            obj.SelectionSphere = [];
            obj.Guide           = [];
            obj.GuideVisible    = false;
        end
        
        function [obj] = buildSelectionInterface(obj)
            obj.Transform = hgtransform(obj.Parent.AxesHandle);
            [x,y,z] = sphere(20);
            obj.SelectionSphere = surf(x,y,z,...
                                       'EdgeColor','none',...
                                       'FaceColor','y',...
                                       'FaceLighting','none',...
                                       'HandleVisibility','off',...
                                       'HitTest','off',...
                                       'Parent',obj.Transform);
            alpha(obj.SelectionSphere,obj.Brush.Strenght);
        end
        
        function [obj] = selectionInterfaceStandby(obj,status)
            set(obj.SelectionSphere,'Visible',~status);
        end
        
        function [obj] = selectionInterfaceUpdate(obj)
            if( isempty(obj.Brush.Position) )
                obj.SelectionSphere.Visible = 'off';
                return;
            end
            obj.SelectionSphere.Visible = 'on';
            alpha(obj.SelectionSphere,obj.Brush.Strenght);
            T = makehgtform('translate',obj.Brush.Position);
            S = makehgtform('scale',obj.Brush.Radius);
            set(obj.Transform,'Matrix',T*S);  
        end
        
        function guideInterfaceStandby(obj,status)
            if(~isempty(obj.Guide))
                if(status)
                    set(obj.Guide,'Visible','off');
                else
                    set(obj.Guide,'Visible',obj.GuideVisible);
                end
            end
        end
    end
    
    methods( Access = protected, Sealed = true )
        function [i] = computeBufferIndex(obj,currentPoint,windowSize)
            i   = GetBufferDataIndex(windowSize,currentPoint,size(obj.MBuffer));
            if( isempty(i) )
                return;
            end
            i(~obj.MBuffer(sub2ind(size(obj.MBuffer),i(:,1),i(:,2))),:) = [];
        end
        
        function [P] = readBufferPoint(obj,bufferIndex)
            P = [];
            if(isempty(bufferIndex))
                return;
            end
            P = fetchPositionData(obj.PBuffer,obj.MinPoint,obj.MaxPoint,bufferIndex);
        end
    end
end