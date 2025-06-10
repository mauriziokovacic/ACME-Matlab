function [Value] = WeightPainter2D(P,N,T,Value)
if( nargin < 4 || isempty(Value) )
    Value = zeros(row(P),1);
end
fig  = CreateViewer3D('right');
ax   = get_axes(fig);
mesh = display_mesh(P,N,T,zeros(row(P),1),'face',[]);
h    = annotation(fig,'ellipse',[0 0 0 0]);
h.Visible = false;
fig.Units = 'pixel';
ax.Units  = 'pixel';
h.Units   = 'pixel';
caxis([0 1]);
Brush = WeightBrush(0.5,30,0.1);
% set(fig,'WindowButtonMotionFcn',@(obj,event) PaintEvent(obj.CurrentPoint,P,N,Value,mesh,h,Brush));

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

function [Q,X,i] = SelectPoint(ax,P,N,B,recompute)
persistent PBuffer;
persistent MBuffer;
persistent Min Max;
persistent KDTree;
if(isempty(KDTree))
    KDTree  = KDTreeSearcher(P);
end
if( isempty(MBuffer) || recompute )
    Min = min(P);
    Max = max(P);

    MBuffer = ReadBufferMask(ax);
    PBuffer = ReadBufferPosition(ax,Min,Max);
end
if( ~isempty(B) )
    Q = [];
    X = [];
    i = [];
    b = GetBufferDataIndex(ax.Parent.Position(3:4),...
                           ax.Parent.CurrentPoint,...
                           size(MBuffer));
    
    Q      = b;
    b      = round(b-B.Radius);
    r      = round(2*B.Radius);
    [m,ix] = matrix_block(MBuffer,b,[r r]);
    x      = find(m);
    if( ~isempty(x) )
        p = matrix_block(PBuffer,b,[r r]);
        p = reshape(permute(p,[2 1 3]),row(p)*col(p),3,1);
        p = p(x,:);
        [p,ip] = unique(p,'stable','rows');
        x = x(ip);
        p = color2position(p,Min,Max);

        [i,j] = ind2sub(size(m),x);
        X = [i j]+ix;
        i = knnsearch(KDTree,p,'K',1);
        [i,ii] = unique(i);
        X = X(ii,:);
    end
end
end

function [Value] = BrushVertex(P,N,Value,Brush,recompute)
if( nargin < 6 )
    recompute = false;
end
ax       = handle(gca);
[Q,X,k]  = SelectPoint(ax,P,N,Brush,recompute);
Value(k) = Brush.eval(Q,X,Value(k));
end

function [h] = update_circle(h,B)
fig = ancestor(h,'figure');
h.Position = [fig.CurrentPoint-B.Radius/2 B.Radius B.Radius];
end

function [VData] = PaintEvent(P,N,VData,mesh,Brush)
persistent Value;
if(nargin==0)
    VData = Value;
    clear Value;
    return;
end
if(isempty(Value))
    Value = VData;
end
Value = BrushVertex(P,N,Value,Brush);
mesh.FaceVertexCData = Value;
end


function MouseEvent(object,event,P,N,Value,mesh,h,Brush)
persistent press;
if(isempty(press))
    press = false;
end
if( nargin == 0 )
    press = false;
    return;
end
switch event.EventName
    case 'WindowScrollWheel'
        s = 1-event.VerticalScrollCount*0.1;
        if( s <= 0 )
            return;
        end
        Brush.setRadius(Brush.Radius*s);
    case 'WindowMousePress'
        press = true;
        if(isRightClick())
            Brush.invert();
        else
            Brush.invert();
        end
        PaintEvent(P,N,Value,mesh,Brush);
    case 'WindowMouseRelease'
        press = false;
    case 'WindowMouseMotion'
        if(press)
            PaintEvent(P,N,Value,mesh,Brush);
        end
    otherwise
        disp(event.EventName);
end
update_circle(h,Brush);
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
            SelectPoint(handle(gca),P,N,[],true);
        end
        ButtonPressed = true;
        h.Visible = true;

        set(fig,'WindowButtonMotionFcn',@(obj,event) MouseEvent(obj,event,P,N,Value,mesh,h,Brush));
        set(fig,'WindowButtonDownFcn',@(obj,event) MouseEvent(obj,event,P,N,Value,mesh,h,Brush));
        set(fig,'WindowButtonUpFcn',@(obj,event) MouseEvent(obj,event,P,N,Value,mesh,h,Brush));
        set(fig,'WindowScrollWheelFcn',@(obj,event) MouseEvent(obj,event,P,N,Value,mesh,h,Brush));
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