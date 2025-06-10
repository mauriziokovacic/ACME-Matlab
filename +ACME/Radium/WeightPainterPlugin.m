classdef WeightPainterPlugin < AbstractPainterPlugin
    methods
        function [obj] = WeightPainterPlugin(varargin)
            obj@AbstractPainterPlugin(varargin{:});
            obj.Brush = MyBrush.WeightBrush(0.5);
        end
        
        function [obj] = connectProgramData(obj,program)
            obj.buildOutputData('WeightPainterData','Value');
        end
        
        function [obj] = createUserInterface(obj,program)
            obj.buildStandardMenu(program,'Weight');
        end
        
        function [obj] = activationRoutine(obj,program)
            obj.Input = program.getData('MeshData');
            obj.Input = obj.Input.Handle;
            if(row(obj.Output.Value)~=row(obj.Input.Vertices))
                obj.Output.Value = zeros(row(obj.Input.Vertices),1);
            end
            DisplayScalarFunction(obj.Input,obj.Output.Value);
            caxis([0 1]);
            obj.buildPickerData(obj.Input.Vertices);
            obj.buildPainterData();
            
            h = get_colorbar(program.FigureHandle);
            h.Label.String = 'Brush Value';
            h.Position = [0.9 0.1 0.03 0.8];
            a = annotation('line',...
                'Color','r',...
                'LineWidth',2,...
                'X',[0.9 0.93],...
                'Y', repmat(0.1+obj.Brush.Value*0.8,1,2),...
                'HitTest','off',...
                'PickableParts','none',...
                'HandleVisibility','off');
            h.ButtonDownFcn = @(o,e) cellfun(@(x) feval(x,o,e),...
                {@(o,e) obj.Brush.setValue(e.IntersectionPoint(2)),...
                 @(o,e) set(a,'X',[0.9 0.93], 'Y', repmat(0.1+obj.Brush.Value*0.8,1,2)),...
                },'UniformOutput',false);
            h.DeleteFcn = @(varargin) delete(a);
            
        end
        
        function [obj] = deactivationRoutine(obj,program)
            obj.destroyPickerData();
            obj.destroyPainterData();
            delete(obj.Guide);
            obj.Guide = [];
            obj.GuideVisible = false;
            DisplayColor(obj.Input,[1 1 1]);
            colorbar(program.AxesHandle,'off');
        end
        
        function [obj] = standbyRoutine(obj,varargin)
            obj.standbyPainterData(obj.isStandby());
            obj.guideInterfaceStandby(obj.isStandby());
        end
        
        function BrushVertex(obj)
            [X,i] = obj.selectInRangePoint(obj.Brush.Position,obj.Brush.Radius);
            obj.Output.Value(i) = obj.Brush.eval(X,obj.Output.Value(i));
            obj.updateGraphics();
        end
        
        function [obj] = EventMouseLeftClick(obj,source,event)
            obj.Brush.PaintFcn = 'mix';
            EventMouseLeftClick@AbstractPainterPlugin(obj,source,event);
            if(isempty(event.Modifier))
                obj.BrushVertex();
            end
        end
        
        function [obj] = EventMouseRightClick(obj,source,event)
            obj.Brush.PaintFcn = 'sub';
            if(isempty(event.Modifier))
                obj.BrushVertex();
            end
        end
        
        function [obj] = EventMouseRightGrab(obj,source,event)
            obj.BrushVertex();
        end
        
        function [obj] = EventMouseMove(obj,source,event)
            bufferIndex = obj.computeBufferIndex(event.Position,obj.Parent.FigureHandle.Position(3:4));
            obj.Brush.Position = obj.readBufferPoint(bufferIndex);
            obj.selectionInterfaceUpdate();
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
        
        function updateGraphics(obj)
            DisplayColor(obj.Input,obj.Output.Value);
        end
    end
    
    methods( Access = protected )
        function importFromWorkspace(obj,varargin)
            prompt = {'Enter Workspace name:',...
                      'Enter Weights name:'};
            title = 'Import from Workspace...';
            dims = [1 35];
            definput = {'base','U'};
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
                      'Enter Weights name:'};
            title = 'Export to Workspace...';
            dims = [1 35];
            definput = {'base','U'};
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