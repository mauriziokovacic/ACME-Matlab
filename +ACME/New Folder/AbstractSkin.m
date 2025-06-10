classdef AbstractSkin < handle
    properties( Access = public, SetObservable )
        Mesh   % Mesh handle
        Weight
        Name
    end
    
    properties( Access = private )
        WListener
        WTree
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = AbstractSkin(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Mesh',   [],          @(data) isa(data,'AbstractMesh'));
            addParameter( parser, 'Weight', sparse(0,0), @(data) isnumeric(data));
            addParameter( parser, 'Name',   '',          @(data) isstring(data)||ischar(data));
            parse(parser,varargin{:});
            obj.WListener = addlistener(obj,'Weight','PostSet',@obj.updateTree);
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function [n] = nHandle(obj)
            n = arrayfun(@(o) col(o.Weight),obj);
        end
        
        function klimit(obj,K)
            for i = 1 : numel(obj)
                obj(i).Weight = limit_weights(obj(i).Weight,K);
            end
        end
        
        function addHandle(obj)
            obj.Weight = [obj.Weight sparse(row(obj.Weight),1)];
        end
        
        function [h] = show_weight(obj,weightIndex)
            h = obj.Mesh.show(obj.Weight(:,weightIndex));
        end
        
        function [M] = extract(obj,weightIndex)
            i = find(vertex2face(obj.Weight(:,weightIndex),obj.Mesh.Face));
            [P,N,UV,T] = submesh(obj.Mesh.Vertex,...
                                 obj.Mesh.Normal,...
                                 obj.Mesh.UV,...
                                 obj.Mesh.Face,...
                                 i,'face');
            M = eval(strcat(class(obj.Mesh),...
                            '(''Vertex'',P,''Normal'',N,''UV'',UV,''Face'',T)'));
        end
        
        function [i] = knn(obj,QueryPoint,k)
            if(nargin<3)
                k = 1;
            end
            i = unique(cell2mat(knnsearch(obj.WTree,...
                                          QueryPoint,...
                                          'K',k,...
                                          'IncludeTies',true)));
        end
        
        function [i] = rnn(obj,QueryPoint,r)
            if(nargin<3)
                r = 1;
            end
            i = unique(cell2mat(rangesearch(obj.WTree,QueryPoint,r)));
        end
        
        function load(obj,filename)
            copy(obj,AbstractSkin.LoadFromFile(filename));
        end
        
        function save(obj,filename)
            AbstractSkin.SaveToFile(obj,filename);
        end
        
        function copy(obj,other)
            prop = properties(obj);
            for i = 1 : numel(prop)
                obj.(prop{i}) = other.(prop{i});
            end
        end
        
        function to_gpu(obj)
            obj.WListener.Enabled = false;
            obj.Weight = gpuArray(obj.Weight);
            obj.WListener.Enabled = true;
        end
    end
    
    methods( Access = private, Hidden = true )
        function updateTree(obj,varargin)
            obj.WTree = ExhaustiveSearcher(obj.Weight);
        end
    end
    
    methods( Static )
        function [obj] = LoadFromFile(filename)
            obj = [];
            [path,name,ext] = fileparts(filename);
            filename = strcat(path,'/',name);
            switch lower(ext)
                case '.skn'
                    [W] = import_SKN(filename);
                otherwise
                    warning('File extension not supported');
                    return;
            end
            obj = AbstractSkin('Weight',W,'Name',name);
        end
        
        function SaveToFile(S,filename)
            warning('File extension not supported');
        end
    end
end