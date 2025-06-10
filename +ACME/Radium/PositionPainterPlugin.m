classdef PositionPainterPlugin < AbstractPainterPlugin
    properties
        ValuePoint
    end
    
    methods
        function [obj] = PositionPainterPlugin(varargin)
            obj@AbstractPainterPlugin(varargin{:});
            obj.Brush = MyBrush.PositionBrush([0 0 0]);
        end
        
        function [obj] = connectProgramData(obj,program)
            obj.buildOutputData('PositionPainterData','Value');
        end
        
        function [obj] = createUserInterface(obj,program)
            obj.buildStandardMenu(program,'Position');
        end
        
        function [obj] = activationRoutine(obj,program)
            obj.Input = program.getData('MeshData');
            obj.Input = obj.Input.Handle;
            obj.buildPickerData(obj.Input.Vertices);
            obj.buildPainterData();
            if(row(obj.Output.Value)~=row(obj.Input.Vertices))
                obj.Output.Value = zeros(size(obj.Input.Vertices));
            end
            DisplayColor(obj.Input,position2color(obj.Output.Value,obj.MinPoint,obj.MaxPoint));
        end
        
        function [obj] = deactivationRoutine(obj,program)
            obj.destroyPickerData();
            obj.destroyPainterData();
            delete(obj.ValuePoint);
            obj.ValuePoint = [];
            DisplayColor(obj.Input,[1 1 1]);
        end
        
        function [obj] = standbyRoutine(obj,varargin)
            obj.standbyPainterData(obj.isStandby());
            obj.valueInterfaceStandby(obj.isStandby());
        end
        
        function BrushVertex(obj)
            [X,i] = obj.selectInRangePoint(obj.Brush.Position,obj.Brush.Radius);
%             obj.Output.Value(i,:) = obj.Brush.eval(obj.Brush.Position,X,obj.Output.Value(i,:));
            obj.Output.Value(i,:) = obj.Brush.eval(X,obj.Output.Value(i,:));
            DisplayColor(obj.Input,position2color(obj.Output.Value,obj.MinPoint,obj.MaxPoint));
        end
        
        function [obj] = EventKeyPress(obj,source,event)
            switch event.Key
                case 'g'
                    if(~isempty(obj.Guide))
                        obj.GuideVisible = ~obj.GuideVisible;
                        set(obj.Guide,'Visible',obj.GuideVisible);
                    else
                        obj.loadGuide();
                    end
            end
        end
        
%         function [obj] = EventMouseLeftClick(obj,source,event)
%             EventMouseLeftClick@AbstractPainterPlugin(obj,source,event);
%             if(any(strcmpi(event.Modifier,'control')))
%                 obj.Brush.Value = obj.Brush.Position();
%                 obj.valueInterfaceUpdate();
%             end
%         end

        function [obj] = EventMouseLeftClick(obj,source,event)
            if(any(strcmpi(event.Modifier,'shift')))
                P = (event.Position-1)./(obj.Parent.FigureHandle.Position(3:4)-1);
                obj.Stroke = annotation('line',...
                                        repmat(P(1),1,2),...
                                        repmat(P(2),1,2),...
                                        'LineWidth',2,'Color','r',...
                                        'Units','pixel');
            else
                obj.BrushVertex();
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
        
        function [obj] = EventMouseLeftRelease(obj,source,event)
            if(any(strcmpi(event.Modifier,'shift')))
                pixel       = bresenham(obj.Stroke.X,obj.Stroke.Y);
                bufferIndex = obj.computeBufferIndex(pixel,...
                                                     obj.Parent.FigureHandle.Position(3:4));
                obj.Brush.Position = obj.readBufferPoint(bufferIndex);
                obj.Brush.Value    = obj.Brush.Position(end,:);
                obj.BrushVertex();
                delete(obj.Stroke);
                obj.Stroke = [];
            end
        end
        
        function [obj] = EventMouseMove(obj,source,event)
            EventMouseMove@AbstractPainterPlugin(obj,source,event);
            obj.Brush.Value = obj.Brush.Position;
        end
        
        function [obj] = valueInterfaceUpdate(obj)
            delete(obj.ValuePoint);
            if( isempty(obj.Brush.Position) )
                return;
            end
            obj.ValuePoint = point3(obj.Brush.Position,20,'filled','r');
        end
        
        function [obj] = valueInterfaceStandby(obj,status)
            if(~isempty(obj.ValuePoint))
                set(obj.ValuePoint,'Visible',~status);
            end
        end
    end
    
    methods( Access = protected )
        function importFromWorkspace(obj,varargin)
            prompt = {'Enter Workspace name:',...
                      'Enter Points name:'};
            title = 'Import from Workspace...';
            dims = [1 35];
            definput = {'base','P_'};
            input = inputdlg(prompt,title,dims,definput);
            if(~isempty(input))
                obj.Output.Value = evalin(input{1},input{2});
                if(obj.isActive())
                    obj.updateGraphics();
                end
            end
        end
        
        function importFromFile(obj,varargin)
            disp('Not implemented yet.');
        end
        
        function exportToWorkspace(obj,varargin)
            prompt = {'Enter Workspace name:',...
                      'Enter Points name:'};
            title = 'Export to Workspace...';
            dims = [1 35];
            definput = {'base','P_'};
            input = inputdlg(prompt,title,dims,definput);
            if(~isempty(input))
                assignin(input{1},input{2},obj.Output.Value);
            end
        end
        
        function exportToFile(obj,varargin)
            disp('Not implemented yet.');
        end
    end
end