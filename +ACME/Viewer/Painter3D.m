function Painter3D(P,N,T,verbose)
if( nargin < 4 || isempty(verbose) )
    verbose = false;
end

fig  = CreateViewer3D('right');
mesh = display_mesh(P,N,T,[],[],[],'HandleVisibility','off');

rotate3d off;

set(fig,'KeyPressFcn',@(object,event) KeyEventHandler(true,event,verbose));
set(fig,'KeyReleaseFcn',@(object,event) KeyEventHandler(false,event,verbose));

set(mesh,'ButtonDownFcn',[]);

end

function KeyEventHandler(tf,event,verbose)
persistent flag;
if( isempty(flag) )
    flag = false;
end
if( nargin == 0 )
    tf = false;
end
if( numel(event.Modifier) > 0 )
    for i = 1 : numel(event.Modifier)
        if( strcmpi(event.Modifier{i},event.Key) )
            return;
        end
    end
end
if( flag == tf )
    return;
end
flag = tf;
if( verbose )
    txt = [];
    if( flag )
        txt = strcat('Pressed',{' '});
    else
        txt = strcat('Released',{' '});
    end
    for i = 1 : numel(event.Modifier)
        txt = strcat(txt,capital(event.Modifier{i}),'+');
    end
    txt = char(strcat(txt,upper(event.Key)));
    disp(txt);
end
end

function Action()
end

