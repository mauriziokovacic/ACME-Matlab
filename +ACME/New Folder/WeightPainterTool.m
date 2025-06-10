classdef WeightPainterTool < PainterTool
    properties
        Position
        Transform
        SelectionSphere
    end
    
    methods
        function [obj] = WeightPainterTool(varargin)
            obj@PainterTool(varargin{:});
            setTitle(obj,'Weight Painter Tool');
            obj.Parent.Weight = zeros(obj.Parent.Mesh.nVertex(),1);
            obj.ObjectHandle.FaceColor       = 'interp';
            obj.ObjectHandle.FaceVertexCData = obj.Parent.Weight;
            caxis([0 1]);
            cmap('king',256);
        end
    end
    
    methods
        function registerProps(obj)
            registerProps@PainterTool(obj);
            addProps(obj,'Mesh');
            addProps(obj,'WeightBrush');
            addProps(obj,'Weight');
        end
    end
    
    methods( Access = protected )
        function createSelectionInterface(obj)
            obj.Transform = hgtransform(obj.AxesHandle.AxesHandle);
            [x,y,z] = sphere(20);
            delete(obj.SelectionSphere);
            obj.SelectionSphere = surf(x,y,z,...
                                       'EdgeColor','none',...
                                       'FaceColor',Cyan(),...
                                       'FaceLighting','none',...
                                       'HandleVisibility','off',...
                                       'HitTest','off',...
                                       'Parent',obj.Transform);
            alpha(obj.SelectionSphere,obj.Parent.WeightBrush.Strength);
        end
        
        function removeSelectionInterface(obj)
            delete(obj.Transform);
            delete(obj.SelectionSphere);
            obj.Transform = [];
            obj.SelectionSphere = [];
            obj.Position = [];
        end

        
        function selectionInterfaceUpdate(obj)
            B = getProps(obj,'WeightBrush');
            if( isempty(obj.Position) )
                obj.SelectionSphere.Visible = 'off';
                return;
            end
            if(~isempty(obj.SelectionSphere))
                obj.SelectionSphere.Visible = 'on';
                alpha(obj.SelectionSphere,B.Strength);
                T = makehgtform('translate',obj.Position);
                S = makehgtform('scale',B.Radius);
                set(obj.Transform,'Matrix',T*S);
            end
        end
        
        function mouseMoveRoutine(obj,source,event)
            i = obj.Buffer.computeBufferIndex(event.Position);
            i = readBufferPosition(obj.Buffer,i);
            obj.Position = i;
        end
        
        function mouseLeftClickRoutine(obj,~,event)
            i = obj.Buffer.computeBufferIndex(event.Position);
            i = readBufferPosition(obj.Buffer,i);
            obj.Position = i;
            obj.BrushVertex();
        end
        
        function mouseLeftGrabRoutine(obj,source,event)
            i = obj.Buffer.computeBufferIndex(event.Position);
            i = readBufferPosition(obj.Buffer,i);
            obj.Position = i;
            obj.BrushVertex();
        end
        
        function mouseLeftGrabReleaseRoutine(obj,source,event)
        end
        
        function mouseScrollRoutine(obj,source,event)
            B = getProps(obj,'WeightBrush');
            s = 1-event.Data.VerticalScrollCount*0.1;
            if( s <= 0 )
                return;
            end
            if(any(strcmpi(event.Modifier,'control')))
                B.Strength = B.Strength*s;
            else
                if(any(strcmpi(event.Modifier,'alt')))
                    B.Value = clamp(B.Value*s,0,1);
                else
                B.Radius = B.Radius*s;
                end
            end
            setProps(obj,'WeightBrush',B);
        end
        
        function BrushVertex(obj)
            if(isempty(obj.Position))
                return;
            end
            M     = getProps(obj,'Mesh');
            B     = getProps(obj,'WeightBrush');
            W     = getProps(obj,'Weight');
            i     = M.rnn(obj.Position,B.Radius);
            W(i)  = B.eval(obj.Position,M.Vertex(i,:),W(i));
            setProps(obj,'Weight',W);
            obj.ObjectHandle.FaceVertexCData = W;
        end
    end
end