function CPSOperatorViewer( Op )

res = 512;

V = Op.op2img(res);

initial_slice = 0;
                  
f = figure( 'Position', [20 20 800 800] );
slider = uicontrol( 'Parent', f, 'Style', 'slider', 'Position', [80, 10, 700, 23], 'value', initial_slice, 'min', 0, 'max', 1 );
addlistener( slider, 'ContinuousValueChange', @( es, ed ) CPSOperatorViewerSlice( V, es.Value ) );
CPSOperatorViewerSlice( V, initial_slice );

end

