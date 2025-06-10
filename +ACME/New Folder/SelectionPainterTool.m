classdef SelectionPainterTool < PainterTool
    properties
        Position
        Transform
        SelectionSphere
    end
    
    methods
        function [obj] = SelectionPainterTool(varargin)
            obj@PainterTool(varargin{:});
            setTitle(obj,'Selection Painter Tool');
            obj.ObjectHandle.FaceColor       = 'interp';
            obj.ObjectHandle.FaceVertexCData = zeros(nVertex(obj.Parent.Mesh),1);
            caxis([0 1]);
            cmap('king',2);
        end
    end
    
    methods
        function registerProps(obj)
            registerProps@PainterTool(obj);
            addProps(obj,'Mesh');
            addProps(obj,'WeightBrush');
            addProps(obj,'VertexIndex');
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
            alpha(obj.SelectionSphere,0.2);
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
                alpha(obj.SelectionSphere,0.2);
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
            B.Radius = B.Radius*s;
            setProps(obj,'WeightBrush',B);
        end
        
        function BrushVertex(obj)
            if(isempty(obj.Position))
                return;
            end
            M     = getProps(obj,'Mesh');
            B     = getProps(obj,'WeightBrush');
            V     = getProps(obj,'VertexIndex');
            i     = make_column(M.rnn(obj.Position,B.Radius));
            V     = unique([V;i]);
            setProps(obj,'VertexIndex',V);
            C     = zeros(nVertex(M),1);
            C(V)  = 1;
            obj.ObjectHandle.FaceVertexCData = C;
        end
    end
end