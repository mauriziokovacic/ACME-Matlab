function [ fig ] = display_mesh( P, N, T, C, primitiveMode, M, varargin )
if( nargin < 6 || isempty(M) )
    M = Material(...
        'FaceColor', Clay(),...
        'FaceAlpha', 1,...
        'AmbientStrength', 0.3,...
        'SpecularDiffuseStrength', 0.6,...
        'SpecularStrength', 0.3,...
        'SpecularExponent', 100,...
        'SpecularColorReflectance', 0.5);
end
if( nargin < 5 || isempty(primitiveMode) )
    primitiveMode = 'face'; % point/vertex, wireframe, wired, face/solid
end
if( isempty(T) )
    primitiveMode = 'vertex';
end

primitiveMode = lower(primitiveMode);

if( nargin < 4 )
    C = [];
end

if( ~isempty(C) && col(C) == 1 )
    M.setMatte();
end

fig = patch( 'Faces',           full(poly2equal(T)),...
             'Vertices',        full(P),...
             'VertexNormals',   full(N),...
             'EdgeColor',       'none',...
             'FaceLighting',    'phong',...
             'AlphaDataMapping','none',...
             'BackFaceLighting','lit' );
apply(M,fig);
if(nargin>6)
    set(fig,varargin{:});
end
    
if( ~isempty(C) )
    if( issparse(C) )
        C = full(C);
    end
    if( islogical(C) )
        C = double(C);
    end
    C(~isfinite(C)) = NaN;
    A = ones(row(C),1);
    if( col(C) == 4 )
        A = C(:,4);
        C = C(:,1:3);
    end
    DisplayColor(fig,C);
    DisplayTransparent(fig,A);
end

if( strcmpi( primitiveMode, 'vertex' ) || strcmpi( primitiveMode, 'point' ) )
    DisplayPoints(fig,C);
end

if( strcmpi( primitiveMode, 'wireframe' ) )
    fig.FaceColor = 'none';
    if( ~isempty(C) )
        C = [0 0 0];
    end
    if( row(C) == 1 )
        fig.EdgeColor = C;
    else
        if( row(C) == row(P) )
            fig.EdgeColor = 'interp';
        else
            fig.EdgeColor = [0 0 0];
        end
    end
end

if( strcmpi( primitiveMode, 'wired' ) )
    fig.EdgeColor = [0 0 0];
end

if( strcmpi( primitiveMode, 'face' ) || strcmpi( primitiveMode, 'solid' ) )
    fig.EdgeColor = 'none';
end

end