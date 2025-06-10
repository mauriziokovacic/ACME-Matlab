classdef NormalPainterPlugin < AbstractPainterPlugin
    properties
        ValuePlane
        PlaneDirection
        PlaneLine
    end
    
    properties
        PData
    end
    
    methods
        function [obj] = NormalPainterPlugin(varargin)
            obj@AbstractPainterPlugin(varargin{:});
            obj.Brush = MyBrush.NormalBrush([0 0 0]);
        end
        
        function [obj] = connectProgramData(obj,program)
            obj.buildOutputData('NormalPainterData','Value');
        end
        
        function [obj] = createUserInterface(obj,program)
            obj.buildStandardMenu(program,'Normal');
        end
        
        function [obj] = activationRoutine(obj,program)
            obj.Input = program.getData('MeshData');
            obj.Input = obj.Input.Handle;
            obj.PData = program.getData('PositionPainterData').Value;
            obj.buildPickerData(obj.Input.Vertices);
%             obj.buildPickerData(obj.PData,min(obj.Input.Vertices),max(obj.Input.Vertices));
            obj.buildPainterData();
            if(row(obj.Output.Value)~=row(obj.Input.Vertices))
                obj.Output.Value = zeros(size(obj.Input.Vertices));
            end
            obj.Brush.Radius = 0.2 * mesh_scale(obj.Input.Vertices);
            DisplayColor(obj.Input,normal2color(obj.Output.Value));
            
            
            
            h = program.getToolBar();
            uipushtool(h,'CData',zeros(16,16,3),'ClickedCallback',@(varargin) obj.Brush.copy(MyBrush.AssignBrush(obj.Brush.Value)));
            uipushtool(h,'CData',ones(16,16,3), 'ClickedCallback',@(varargin) obj.Brush.copy(MyBrush.NormalBrush([0 0 0])));
        end
        
        function [obj] = deactivationRoutine(obj,program)
            obj.destroyPickerData();
            obj.destroyPainterData();
            delete(obj.ValuePlane);
            obj.ValuePlane = [];
            delete(obj.PlaneLine);
            obj.PlaneLine = [];
            DisplayColor(obj.Input,[1 1 1]);
            h = program.getToolBar();
            delete(h);
        end
        
        function [obj] = standbyRoutine(obj,varargin)
            obj.standbyPainterData(obj.isStandby());
            obj.valueInterfaceStandby(obj.isStandby());
            obj.guideInterfaceStandby(obj.isStandby());
        end
        
        function BrushVertex(obj)
            [X,i] = obj.selectInRangePoint(obj.Brush.Position,obj.Brush.Radius);
            obj.Output.Value(i,:) = obj.Brush.eval(X,obj.Output.Value(i,:));
            
            obj.Output.Value = reorient_plane(obj.PData,obj.Output.Value,obj.Input.Vertices);
            
            DisplayColor(obj.Input,normal2color(obj.Output.Value));
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
        
        function [obj] = EventMouseRightClick(obj,source,event)
            D = (event.Position-1)./(obj.Parent.FigureHandle.Position(3:4)-1);
            delete(obj.PlaneLine);
            obj.PlaneLine = annotation('line',repmat(D(1),1,2),repmat(D(2),1,2),'LineWidth',2,'Color','r');
            D = (D-0.5) / 0.5;
            obj.PlaneDirection = D;
        end
        
        function [obj] = EventMouseRightRelease(obj,source,event)
            D = (event.Position-1)./(obj.Parent.FigureHandle.Position(3:4)-1);
            D = (D-0.5) / 0.5;
            obj.PlaneDirection = D-obj.PlaneDirection;
            obj.Brush.Value = obj.PlaneDirection(2) .* ...
                              cross(obj.Parent.AxesHandle.CameraUpVector,get_camera_direction(obj.Parent.AxesHandle),2) +...
                              obj.PlaneDirection(1) .* ...
                              obj.Parent.AxesHandle.CameraUpVector;
            obj.Brush.Value = normr(obj.Brush.Value);
            obj.valueInterfaceUpdate();
            delete(obj.PlaneLine);
            obj.PlaneLine = [];
        end
        
        function [obj] = EventMouseMove(obj,source,event)
            EventMouseMove@AbstractPainterPlugin(obj,source,event);
            obj.valueInterfaceUpdate();
            if(~isempty(obj.PlaneLine))
                D = (event.Position-1)./(obj.Parent.FigureHandle.Position(3:4)-1);
                obj.PlaneLine.X(2) = D(1);
                obj.PlaneLine.Y(2) = D(2);
            end
        end
        
        function [obj] = EventMouseScroll(obj,source,event)
            EventMouseScroll@AbstractPainterPlugin(obj,source,event);
            obj.valueInterfaceUpdate();
        end
        
        function [obj] = valueInterfaceUpdate(obj)
            delete(obj.ValuePlane);
            if( isempty(obj.Brush.Position) )
                return;
            end
            obj.ValuePlane = plane3(obj.Brush.Position,...
                                    obj.Brush.Value,...
                                    obj.Brush.Radius,[1 1 0 0.5],...
                                    'Parent',obj.Parent.AxesHandle,...
                                    'HandleVisibility','off',...
                                    'HitTest','off');
        end
        
        function [obj] = valueInterfaceStandby(obj,status)
            if(~isempty(obj.ValuePlane))
                set(obj.ValuePlane,'Visible',~status);
            end
        end
        
    end
    
    methods( Access = protected )
        function importFromWorkspace(obj,varargin)
            prompt = {'Enter Workspace name:',...
                      'Enter Normals name:'};
            title = 'Import from Workspace...';
            dims = [1 35];
            definput = {'base','N_'};
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
                      'Enter Normals name:'};
            title = 'Export to Workspace...';
            dims = [1 35];
            definput = {'base','N_'};
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