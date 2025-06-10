function [Value] = WeightPainter3D(P,N,T,Value)
if( nargin < 4 || isempty(Value) )
    Value = zeros(row(P),1);
end
fig  = CreateViewer3D('right');
ax   = get_axes(fig);
mesh = display_mesh(P,N,T,zeros(row(P),1),'face',[]);

hold on;
t = hgtransform(ax);
[x,y,z]   = sphere(20);
h         = surf(x,y,z,...
                 'EdgeColor','none',...
                 'FaceColor','y',...
                 'FaceLighting','none');
alpha(h,0.15);
h.HandleVisibility = 'off';
h.Visible = false;
set(h,'Parent',t);

fig.Units = 'pixel';
ax.Units  = 'pixel';
caxis([0 1]);
Brush = WeightBrush3D(0.5,30,0.1);

set(fig,'KeyPressFcn',@(object,event) EventHandler(object,event,true,P,N,Value,mesh,h,Brush));
set(fig,'KeyReleaseFcn',@(object,event) EventHandler(object,event,false,P,N,Value,mesh,h,Brush));
set(fig,'DeleteFcn',@(object,event) EventHandler());

run = true;
while( run )
    if( ~isvalid(fig) )
        return;
    end
    char = get(fig, 'CurrentCharacter');
    if( char == 13 )
        run = false;
    end
    drawnow;
end
if( isvalid(mesh) )
    [~,Value] = EventHandler();
end
if( isvalid(fig) )
    close(fig);
end
end

function [Pos] = readData(fig,P,recompute)
persistent MBuffer;
persistent PBuffer;
persistent Min Max;
if(isempty(MBuffer)||recompute)
    Min     = min(P);
    Max     = max(P);
    MBuffer = ReadBufferMask(fig);
    PBuffer = ReadBufferPosition(fig,Min,Max);
end
Pos = [];
i   = GetBufferDataIndex(fig.Position(3:4),...
                         fig.CurrentPoint,...
                         size(MBuffer));
if( MBuffer(i(1),i(2)) )
    Pos = color2position(reshape(PBuffer(i(1),i(2),:),1,3),Min,Max);
end
end

function [X,i] = SelectPoint(P,Q,r)
persistent KDTree;
if(isempty(KDTree))
    KDTree  = KDTreeSearcher(P);
end
X = [];
i = [];
if( isempty(Q) )
    return;
end
    i = cell2mat(rangesearch(KDTree,Q,r))';
    X = KDTree.X(i,:);
end

function [Value] = BrushVertex(P,Brush,Value)
[X,i]    = SelectPoint(P,Brush.Position,Brush.Radius);
Value(i) = Brush.eval(Brush.Position,X,Value(i));
end

function [h] = update_circle(h,Brush)
if( isempty(Brush.Position) )
    h.Visible = 'off';
    return;
end
h.Visible = 'on';
t = h.Parent;
T = makehgtform('translate',Brush.Position);
S = makehgtform('scale',Brush.Radius);
set(t,'Matrix',T*S);
end

function [VData] = PaintEvent(P,VData,h,Brush)
persistent Value;
if(nargin==0)
    VData = Value;
    clear Value;
    return;
end
if(isempty(Value))
    Value = VData;
end
Value = BrushVertex(P,Brush,Value);
h.FaceVertexCData = Value;
end


function MouseEvent(object,event,P,Value,mesh,h,Brush)
persistent press;
if(isempty(press))
    press = false;
end
if( nargin == 0 )
    press = false;
    return;
end
Brush.Position = readData(object,P,false);
update_circle(h,Brush);
switch event.EventName
    case 'WindowScrollWheel'
        s = 1-event.VerticalScrollCount*0.1;
        if( s <= 0 )
            return;
        end
        Brush.setRadius(Brush.Radius*s);
    case 'WindowMousePress'
        press = true;
%         if(isRightClick())
%             Brush.Inverted = true;
%         else
%             Brush.Inverted = false;
%         end
        PaintEvent(P,Value,mesh,Brush);
    case 'WindowMouseRelease'
        press = false;
    case 'WindowMouseMotion'
        if(press)
            PaintEvent(P,Value,mesh,Brush);
        end
    otherwise
        disp(event.EventName);
end
end

function [fig,VData] = EventHandler(fig,event,press,P,N,Value,mesh,h,Brush)
persistent ButtonPressed;
persistent WindowButtonMotionFcn;
persistent WindowButtonDownFcn;
persistent WindowButtonUpFcn;
persistent WindowScrollWheelFcn;
if(nargin==0)
    fig   = [];
    VData = PaintEvent();
    return;
end
if( isempty(ButtonPressed) )
    ButtonPressed = false;
end
if( isempty(WindowButtonMotionFcn) )
    WindowButtonMotionFcn = fig.WindowButtonMotionFcn;
    WindowButtonDownFcn   = fig.WindowButtonDownFcn;
    WindowButtonUpFcn     = fig.WindowButtonUpFcn;
    WindowScrollWheelFcn  = fig.WindowScrollWheelFcn;
end
if( press )
    if( strcmpi(event.Key,'control') )
        if( ~ButtonPressed )
            readData(fig,P,true);
        end
        ButtonPressed = true;
        set(fig,'WindowButtonMotionFcn',@(obj,event) MouseEvent(obj,event,P,Value,mesh,h,Brush));
        set(fig,'WindowButtonDownFcn',@(obj,event) MouseEvent(obj,event,P,Value,mesh,h,Brush));
        set(fig,'WindowButtonUpFcn',@(obj,event) MouseEvent(obj,event,P,Value,mesh,h,Brush));
        set(fig,'WindowScrollWheelFcn',@(obj,event) MouseEvent(obj,event,P,Value,mesh,h,Brush));
    end
else
    if( strcmpi(event.Key,'control') )
        ButtonPressed = false;
        MouseEvent();
        h.Visible = false;
        set(fig,'WindowButtonMotionFcn',WindowButtonMotionFcn);
        set(fig,'WindowButtonDownFcn',WindowButtonDownFcn);
        set(fig,'WindowButtonUpFcn',WindowButtonUpFcn);
        set(fig,'WindowScrollWheelFcn',WindowScrollWheelFcn);
        
    end
end

end