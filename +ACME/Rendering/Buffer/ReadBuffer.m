function [Data] = ReadBuffer(h,readDataFcn,prop)
if(nargin < 3)
    prop = {'FaceLighting','FaceColor','FaceVertexCData'};
end
if(isfigure(h))
    ax = get_axes(h);
end
if( isaxes(h) )
    ax = h;
    h = ax.Parent;
end
p = get_patch(ax);

% Create prop data
for i = 1 : numel(prop)
    eval([prop{i},'= cell(numel(p),1);']);
end

% Save prop data
for i = 1 : numel(p)
    for j = 1 : numel(prop)
        eval([prop{j},'{i} = p(i).',prop{j},';']);
    end
end

% Compute buffer
Data = readDataFcn(h,ax,p);

% Restore prop data
for i = 1 : numel(p)
    for j = 1 : numel(prop)
        eval(['p(i).',prop{j},' = ',prop{j},'{i};']);
    end
end

end