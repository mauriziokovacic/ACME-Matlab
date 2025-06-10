classdef ContactPainterPlugin < AbstractPainterPlugin
    properties
        SpStroke
        PBrush
        NBrush
    end
    
    methods
        function [obj] = ContactPainterPlugin(varargin)
            obj@AbstractPainterPlugin(varargin{:});
            obj.Brush = MyBrush();
            obj.PBrush = MyBrush();
            obj.NBrush = MyBrush();
        end
        
        function [obj] = connectProgramData(obj,program)
            obj.buildOutputData('ContactPainterData',{'Point','Normal','Value'});
        end
        
        function [obj] = createUserInterface(obj,program)
            obj.buildStandardMenu(program,'Contact');
        end
        
        function [obj] = activationRoutine(obj,program)
            obj.Input = program.getData('MeshData');
            obj.Input = obj.Input.Handle;
            obj.buildPickerData(obj.Input.Vertices);
            obj.buildPainterData();
            if(row(obj.Output.Value)~=row(obj.Input.Vertices))
                obj.Output.Point  = zeros(size(obj.Input.Vertices));
                obj.Output.Normal = zeros(size(obj.Input.Vertices));
                obj.Output.Value  = zeros(row(obj.Input.Vertices),1);
            end
            obj.Brush.Radius = 0.2 * mesh_scale(obj.Input.Vertices);
            DisplayColor(obj.Input,position2color(obj.Output.Point,obj.MinPoint,obj.MaxPoint));
        end
        
        function [obj] = deactivationRoutine(obj,program)
            obj.destroyPickerData();
            obj.destroyPainterData();
            DisplayColor(obj.Input,[1 1 1]);
        end
        
        function [obj] = standbyRoutine(obj,varargin)
            obj.standbyPainterData(obj.isStandby());
            obj.guideInterfaceStandby(obj.isStandby());
        end
        
        function BrushVertex(obj)
            [X,i] = obj.selectInRangePoint(obj.Brush.Position,obj.Brush.Radius);
            obj.Output.Point(i,:)  = obj.PBrush.eval(X,obj.Output.Point(i,:));
            obj.Output.Normal(i,:) = obj.NBrush.eval(X,obj.Output.Normal(i,:));
            
            DisplayColor(obj.Input,position2color(obj.Output.Point,obj.MinPoint,obj.MaxPoint));
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
        
        function [obj] = EventMouseLeftClick(obj,source,event)
            EventMouseLeftClick@AbstractPainterPlugin(obj,source,event);
            if(any(strcmpi(event.Modifier,'shift')))
                P = (event.Position-1)./(obj.Parent.FigureHandle.Position(3:4)-1);
                obj.SpStroke = annotation('line',...
                                         repmat(P(1),1,2),...
                                         repmat(P(2),1,2),...
                                         'LineWidth',2,'Color','b',...
                                         'Units','pixel');
            end
        end
        
        function [obj] = EventMouseLeftGrab(obj,source,event)
            EventMouseLeftGrab@AbstractPainterPlugin(obj,source,event);
            if(any(strcmpi(event.Modifier,'shift')))
                obj.SpStroke.X(2) = 2*obj.Stroke.X(1)-event.Position(1);
                obj.SpStroke.Y(2) = 2*obj.Stroke.Y(1)-event.Position(2);
            end
        end
        
        function [obj] = EventKeyRelease(obj,source,event)
            EventKeyRelease@AbstractPainterPlugin(obj,source,event);
            if( strcmpi(event.Key,'shift') )
                delete(obj.SpStroke);
                obj.SpStroke = [];
            end
        end
        
        function [obj] = EventMouseLeftRelease(obj,source,event)
            if(any(strcmpi(event.Modifier,'shift')))
                pixel       = bresenham(obj.Stroke.X,obj.Stroke.Y);
                sppixel     = bresenham(obj.SpStroke.X,obj.SpStroke.Y);
                
                bufferIndex = obj.computeBufferIndex(pixel,...
                                                     obj.Parent.FigureHandle.Position(3:4));
                                                 
                spbufferIndex = obj.computeBufferIndex(sppixel,...
                                                       obj.Parent.FigureHandle.Position(3:4));
                obj.PBrush.Position = obj.Brush.Position;
                obj.NBrush.Position = obj.Brush.Position;
                obj.PBrush.Radius   = obj.Brush.Radius;
                obj.NBrush.Radius   = obj.Brush.Radius;
                
                A = obj.readBufferPoint(  bufferIndex);
                B = obj.readBufferPoint(spbufferIndex);
                X = A(1,:);
                
                Da = distance(A,X);
                Db = distance(B,X);

                for i = 1 : row(A)
                    [~,k]            = min(abs(Db-Da(i,:)));
                    obj.PBrush.Value = X;
                    obj.NBrush.Value = normr(A(i,:)-B(k,:));
                    obj.Brush.Position  = A(i,:);
                    obj.PBrush.Position = A(i,:);
                    obj.NBrush.Position = A(i,:);
                    obj.BrushVertex();
                end
                
                obj.Output.Normal = reorient_plane(obj.Output.Point,...
                                                   obj.Output.Normal,...
                                                   obj.Input.Vertices);
                obj.Output.Value = normalize(distance(obj.Output.Point,obj.Input.Vertices));
                obj.Output.Value(~isfinite(obj.Output.Value)) = 0;
                
                delete(obj.Stroke);
                obj.Stroke = [];
                delete(obj.SpStroke);
                obj.SpStroke = [];
            end
        end
    end
    
    methods( Access = protected )
        function importFromWorkspace(obj,varargin)
            prompt = {'Enter Workspace name:',...
                      'Enter Points name:',...
                      'Enter Normals name:',...
                      'Enter Values name:'};
            title = 'Import from Workspace...';
            dims = [1 35];
            definput = {'base','P_','N_','U'};
            input = inputdlg(prompt,title,dims,definput);
            if(~isempty(input))
                obj.Output.Point  = evalin(input{1},input{2});
                obj.Output.Normal = evalin(input{1},input{3});
                obj.Output.Value  = evalin(input{1},input{4});
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
                      'Enter Points name:',...
                      'Enter Normals name:',...
                      'Enter Values name:'};
            title = 'Export to Workspace...';
            dims = [1 35];
            definput = {'base','P_','N_','U'};
            input = inputdlg(prompt,title,dims,definput);
            if(~isempty(input))
                assignin(input{1},input{2},obj.Output.Point);
                assignin(input{1},input{3},obj.Output.Normal);
                assignin(input{1},input{4},obj.Output.Value);
            end
        end
        
        function exportToFile(obj,varargin)
            disp('Not implemented yet.');
        end
    end
end