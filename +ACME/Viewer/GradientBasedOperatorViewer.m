function GradientBasedOperatorViewer(V,dim,varargin)
persistent input;
if( isempty(input) )
    input = inputParser;
    classes    = {'numeric'};
    attributes = {'>=',1,'<=',3};
    addRequired( input, 'V', @(m) dimension(m)>0 && isnumeric(m));
    addOptional( input, 'dim', 2, @(x) validateattributes(x,classes,attributes));
end
parse(input,V,dim,varargin{:});
[X,Y,Z] = ndgrid(linspace(0,1,size(V,1)),linspace(0,1,size(V,2)),linspace(0,1,size(V,3)));
F       = griddedInterpolant(X,Y,Z,V);

fig    = figure('Name','Gradient Based Operator Viewer');
slider = uicontrol( 'Parent', fig,...
                    'Style', 'slider',...
                    'Position', [80, 10, 700, 23],...
                    'value', 0.5, 'min', 0, 'max', 1 );
addlistener( slider, 'ContinuousValueChange',...
             @(object,event) EventHandler(object,event,F,dim));
EventHandler(slider,[],F,dim)

end


function EventHandler(object,event,F,dim)
persistent U V;
if( isempty(U) )
    [U,V] = ndgrid(linspace(0,1,128));
end
ax = handle(gca);
delete(get(ax,'Children'));
W = repmat(object.Value,size(U));
switch dim
    case 1
        D = F(W,U,V);
    case 2
        D = F(V,W,U);
    otherwise
        D = F(U,V,W);
end
mat2plane(D,[0 1; 0 1]);
colormap(ax,cmap('implicit'));
switch dim
    case 1
        title(strcat('f_i = ', num2str(object.Value)));
        xlabel('f_j');
        ylabel('theta');
    case 2
        xlabel('f_i');
        title(strcat('f_j = ', num2str(object.Value)));
        ylabel('theta');
    otherwise
        xlabel('f_i');
        ylabel('f_j');
        title(strcat('theta = ', num2str(object.Value)));
end
view(2);
axis equal;
end