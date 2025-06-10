classdef AbstractMesh < handle
    properties( Access = public, SetObservable )
        Vertex
        Normal
        UV(:,2)   {mustBeFinite}
        Edge(:,2) {mustBeNumeric, mustBeInteger,...
                   mustBeFinite, mustBeGreaterThan(Edge,0)}
        Face      {mustBeNumeric, mustBeInteger,...
                   mustBeFinite, mustBeGreaterThan(Face,0)}
        Hedra     {mustBeNumeric, mustBeInteger,...
                   mustBeFinite, mustBeGreaterThan(Hedra,0)}
        Name(1,:) char = ''
        
        ExternalVertex(:,1) {mustBeFinite, mustBeNumericOrLogical}
        ExternalEdge(:,1)   {mustBeFinite, mustBeNumericOrLogical}
        ExternalFace(:,1)   {mustBeFinite, mustBeNumericOrLogical}
        ExternalHedra(:,1)  {mustBeFinite, mustBeNumericOrLogical}
    end
    
    properties( Access = private, Hidden = true )
        VListener
        PTree
    end
    
    properties( Access = private, Hidden = true )
        VVAdj
        VEAdj
        VFAdj
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = AbstractMesh(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Vertex', [], @(data) isnumeric(data));
            addParameter( parser, 'Normal', [], @(data) isnumeric(data));
            addParameter( parser, 'UV',     [], @(data) isnumeric(data));
            addParameter( parser, 'Edge',   [], @(data) isnumeric(data));
            addParameter( parser, 'Face',   [], @(data) isnumeric(data)||iscell(data));
            addParameter( parser, 'Hedra',  [], @(data) isnumeric(data)||iscell(data));
            addParameter( parser, 'Name',   '', @(data) isstring(data)||ischar(data));
            parse(parser,varargin{:});
            obj.VListener = addlistener(obj,'Vertex','PostSet',@obj.updateTree);
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
            if(isempty(obj.Edge))
                compute_edge(obj);
            end
            compute_external_face(obj);
            compute_external_vertex(obj);
            compute_external_edge(obj);
            compute_external_hedra(obj);
        end
        
        function [i] = knn(obj,QueryPoint,k,ties)
            i = [];
            if(nargin<4)
                ties = false;
            end
            if(nargin<3)
                k = 1;
            end
            if(isempty(QueryPoint))
                return;
            end
            i = knnsearch(obj.PTree,...
                          QueryPoint,...
                          'K',k,...
                          'IncludeTies',ties);
            if(iscell(i))
                i = cell2mat(i);
            end
%             i = unique(i,'stable');
        end
        
        function [i] = rnn(obj,QueryPoint,r)
            i = [];
            if(nargin<3)
                r = 1;
            end
            if(isempty(QueryPoint))
                return;
            end
            i = cell2mat(rangesearch(obj.PTree,QueryPoint,r));
%             i = unique(i,'stable');
        end
        
        function load(obj,filename)
            assign(obj,AbstractMesh.LoadFromFile(filename));
        end
        
        function save(obj,filename,varargin)
            AbstractMesh.SaveToFile(obj,filename,varargin{:});
        end
        
        function assign(obj,other)
            prop = properties(obj);
            for i = 1 : numel(prop)
                obj.(prop{i}) = other.(prop{i});
            end
        end
        
        function [other] = copy(obj)
            other = AbstractMesh();
            prop = properties(obj);
            for i = 1 : numel(prop)
                other.(prop{i}) = obj.(prop{i});
            end
        end
        
        function [n] = nVertex(obj)
            n = row(obj.Vertex);
        end
        
        function [n] = nEdge(obj)
            n = row(obj.Edge);
        end
        
        function [n] = nFace(obj)
            n = row(obj.Face);
        end
        
        function [n] = nHedra(obj)
            n = row(obj.Hedra);
        end
        
        function [tf] = isempty(obj)
            tf = isempty(obj.Vertex);
        end
        
        function recompute_normals(obj)
            obj.Normal = vertex_normal(obj.Vertex,obj.Face);
        end
        
        function [tf] = isSurfaceMesh(obj)
            tf = ~isempty(obj.Face);
        end
        
        function [tf]  = isTriMesh(obj)
            tf = isSurfaceMesh(obj)&&istri(obj.Face);
        end
        
        function [tf]  = isQuadMesh(obj)
            tf = isSurfaceMesh(obj)&&isquad(obj.Face);
        end
        
        function [tf]  = isQuadDominantMesh(obj)
            tf = isSurfaceMesh(obj)&&isquaddominant(obj.Face);
        end
        
        function [tf]  = isPolygonMesh(obj)
            tf = isSurfaceMesh(obj)&&ispoly(obj.Face);
        end
        
        function [tf]  = isVolumetricMesh(obj)
            tf = ~isempty(obj.Hedra);
        end
        
        function [tf]  = isTetMesh(obj)
            tf = isVolumetricMesh(obj)&&isquad(obj.Hedra);
        end
        
        function [tf]  = isHexMesh(obj)
            tf = isVolumetricMesh(obj)&&ispoly(obj.Hedra,6);
        end
        
        function [tf]  = isPolyhedralMesh(obj)
            tf = isVolumetricMesh(obj)&&ispoly(obj.Hedra);
        end
        
        function [G]   = genus(obj)
            G = genus(obj.Vertex,obj.Edge,obj.Face,obj.Hedra);
        end
        
        function to_gpu(obj)
            name = fieldnames(obj);
            name(strcmpi(name,'Name')) = [];
            obj.VListener.Enabled = false;
            for i = 1 : numel(name)
                obj.(name{i}) = gpuArray(obj.(name{i}));
            end
            obj.VListener.Enabled = true;
        end
        
        function [A] = adjacency(obj,type)
            switch lower(type)
                case 'vv'
                    if(isempty(obj.VVAdj))
                        compute_vertex_vertex_adjacency(obj)
                    end
                    A = obj.VVAdj;
                    return
                case 've'
                    if(isempty(obj.VEAdj))
                        compute_vertex_edge_adjacency(obj)
                    end
                    A = obj.VEAdj;
                    return
                case 'vf'
                    if(isempty(obj.VFAdj))
                        compute_vertex_face_adjacency(obj)
                    end
                    A = obj.VFAdj;
                    return
                otherwise
                    error('Type not supported yet');
            end
        end
    end
    
    methods( Access = public )
        function [h] = show(obj,varargin)
            h = display_mesh( obj.Vertex, obj.Normal, obj.Face, varargin{:} );
%             F = poly2equal(full(obj.Face));
%             M = Material(...
%                     'FaceColor', [1 1 1],...
%                     'FaceAlpha', 1,...
%                     'AmbientStrength', 0.3,...
%                     'SpecularDiffuseStrength', 0.6,...
%                     'SpecularStrength', 0.3,...
%                     'SpecularExponent', 100,...
%                     'SpecularColorReflectance', 0.5);
%             ext = patch(...
%                 'Faces',            F(obj.ExternalFace,:),...
%                 'Vertices',         full(obj.Vertex),...
%                 'VertexNormals',    full(obj.Normal),...
%                 'EdgeColor',        'none',...
%                 'FaceLighting',     'gouraud',...
%                 'AlphaDataMapping', 'none',...
%                 'BackFaceLighting', 'lit' );
%             apply(M,ext);
%             if(nargout>=2)
%                 int = [];
%                 if( isVolumetricMesh(obj) )
%                     M = Material(...
%                         'FaceColor', [1 1 0],...
%                         'FaceAlpha', 0.2,...
%                         'AmbientStrength', 0.3,...
%                         'SpecularDiffuseStrength', 0.6,...
%                         'SpecularStrength', 0.3,...
%                         'SpecularExponent', 100,...
%                         'SpecularColorReflectance', 0.5);
%                     int = patch(...
%                         'Faces',            F(~obj.ExternalFace,:),...
%                         'Vertices',         full(obj.Vertex),...
%                         'VertexNormals',    full(obj.Normal),...
%                         'EdgeColor',        'k',...
%                         'FaceLighting',     'none',...
%                         'AlphaDataMapping', 'none');
%                     apply(M,int);
%                 end
%             end
        end
    end
    
    methods( Access = private, Hidden = true )
        function updateTree(obj,varargin)
            obj.PTree = KDTreeSearcher(obj.Vertex);
        end
        
        function compute_edge(obj)
            if(isempty(obj.Face))
                return;
            end
            obj.Edge = unique(sort(poly2edge(obj.Face),2),'rows');
        end

        function compute_external_vertex(obj)
            obj.ExternalVertex = false(row(obj.Vertex),1);
            if(~isVolumetricMesh(obj))
                obj.ExternalVertex = true(row(obj.Vertex),1);
                return;
            end
            [J,I] = poly2lin(obj.Face);
            obj.ExternalVertex = accumarray(J,obj.ExternalFace(I))>=1;
            obj.ExternalVertex = make_column(obj.ExternalVertex);
        end
        
        function compute_external_edge(obj)
            obj.ExternalEdge = false(row(obj.Edge),1);
            if(~isVolumetricMesh(obj))
                obj.ExternalEdge = true(row(obj.Edge),1);
                return;
            end
            obj.ExternalEdge = obj.ExternalVertex(obj.Edge(:,1)) &&...
                               obj.ExternalVertex(obj.Edge(:,2));
        end
        
        function compute_external_face(obj)
            obj.ExternalFace = false(row(obj.Face),1);
            if(~isVolumetricMesh(obj))
                obj.ExternalFace = true(row(obj.Face),1);
                return;
            end
            [J] = poly2lin(obj.Hedra);
            obj.ExternalFace = accumarray(J,1)==1;
            obj.ExternalFace = make_column(obj.ExternalFace);
        end
        
        function compute_external_hedra(obj)
            obj.ExternalHedra = false(row(obj.Hedra),1);
            if( ~isVolumetricMesh(obj) )
                return;
            end
            [J,I] = poly2ind(obj.Hedra);
            obj.ExternalHedra = accumarray(I,obj.ExternalFace(J))>=1;
            obj.ExternalHedra = make_column(obj.ExternalHedra);
        end
        
        function compute_vertex_vertex_adjacency(obj)
            obj.VVAdj = sparse(obj.Edge(:,[1;2]),obj.Edge(:,[2;1]),1,...
                               row(obj.Vertex),row(obj.Vertex));
        end
        
        function compute_vertex_edge_adjacency(obj)
            obj.VEAdj = sparse(obj.Edge(:),repmat((1:row(obj.Edge))',2,1),1,...
                               row(obj.Vertex),row(obj.Edge));
        end
        
        function compute_vertex_face_adjacency(obj)
            obj.VFAdj = sparse(obj.Face(:),repmat((1:row(obj.Face))',3,1),1,...
                        row(obj.Vertex),row(obj.Face));
        end
    end
    
    methods( Static )
        function [obj] = LoadFromFile(filename)
            obj = [];
            [path,name,ext] = fileparts(filename);
            filename = strcat(path,'/',name);
            switch lower(ext)
                case '.obj'
                    [V,N,UV,F] = import_OBJ(filename);
                case '.off'
                    [V,F] = import_OFF(filename);
                    N  = zeros(size(V));
                    UV = zeros(row(V),2);
                case '.geo'
                    [V,N,UV,F] = import_GEO(filename);
                otherwise
                    warning('File extension not supported');
                    return;
            end
            obj = AbstractMesh('Vertex',V,'Normal',N,'UV',UV,'Face',F,'Name',name);
        end
        
        function SaveToFile(M,filename,varargin)
            [~,~,ext] = fileparts(filename);
            switch lower(ext)
                case '.obj'
                    export_OBJ(filename,...
                               'Point', M.Vertex,...
                               'Normal',M.Normal,...
                               'UV',    M.UV,...
                               'Face',  M.Face,...
                               varargin{:});
                case '.off'
                    export_OFF(filename,'Point',M.Vertex,'Face',M.Face);
                case '.ply'
                    export_PLY(filename,...
                               'Point', M.Vertex,...
                               'Normal',M.Normal,...
                               'UV',    M.UV,...
                               'Face',  M.Face,...
                               varargin{:});
                otherwise
                    warning('File extension not supported');
                    return;
            end
        end
    end
end