function [h,varargout] = CreatePainter3D(varargin)
P = evalin('base','P');
N = evalin('base','N');
T = evalin('base','T');
C = evalin('base','C');

[h,ax] = CreateViewer3D();
rotate3d off;
f = display_mesh(P,N,T,C,'wired');
h.WindowButtonMotionFcn = @(obj,event) create_sphere(obj,event);
h.WindowButtonDownFcn   = @(obj,event) interaction(obj,event);

if( nargout >= 2 )
    varargout{1} = ax;
end
end


function create_sphere(obj,event)
persistent x y z S;
hold on;
if( isempty(x) )
    [x,y,z] = sphere(8);
    x = x * 5;
    y = y * 5;
    z = z * 5;
    S = surf(x,y,z);
end
hold on;
delete(S);
hold on;
c  = event.IntersectionPoint;
dx = x+c(1);
dy = y+c(2);
dz = z+c(3);
S = surf(dx,dy,dz,cat(3,ones(size(x)),ones(size(y)),zeros(size(z))));
alpha(S,0.2);
end


function interaction(obj,event,f)
P = evalin('base','P');
N = evalin('base','N');
T = evalin('base','T');
C = evalin('base','C');

c = event.IntersectionPoint;
if( size(c,1) > 1 )
    c = c';
end
i = find( vecnorm3(P-repmat(c,size(P,1),1)) <= 10 );
j = setdiff(1:size(P,1),i);
C(i) = 1;
% C(j) = 0;
end
