function [out] = orthographicProjections(P,T)
[O,M] = PCA(P);
d     = mesh_scale(P);
% P     = cell2mat(arrayfun(@(i) (M*(P(i,:)-O)')',(1:row(P))','UniformOutput',false));

fig = figure('Name','Orthographic Projection',...
             'NumberTitle','off',...
             'MenuBar',    'none',...
             'ToolBar',    'none');
ax  = CreateAxes3D(fig,'Projection','orthographic');
display_mesh(P,zeros(size(P)),T);


p = num2cell(6*d*[1 0 0; 0 1 0; 0 0 1],2);
u = num2cell([0 1 0; 0 0 1; 0 1 0],2);

out = [];
for i = 1 : 3
    ax.CameraTarget   = [0 0 0];
    ax.CameraPosition = p{i};
    ax.CameraUpVector = u{i};
    I = ReadBufferMask(fig).*(1-ReadBufferDepth(fig));
    I = imdilate(I,strel('disk',10));
    out = [out;{I}];
end
end