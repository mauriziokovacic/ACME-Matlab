classdef MeshImporterPlugin < AbstractPlugin
    properties
        AxesHandle
    end
    
    methods
        function [obj] = MeshImporterPlugin(varargin)
            obj@AbstractPlugin(varargin{:});
        end
        
        function [obj] = connectProgramData(obj,program)
            obj.Output = program.setData('MeshData',MeshContainer());
            obj.AxesHandle = program.AxesHandle;
        end
        
        function [obj] = createUserInterface(obj,program)
            menu  = program.getMenu('File');
            menu = uimenu(menu,'Text','Import');
            mitem = uimenu(menu,'Text','From Workspace...');
            mitem.MenuSelectedFcn = @obj.importFromWorkspace;
            mitem = uimenu(menu,'Text','From file...');
            mitem.MenuSelectedFcn = @obj.importFromFile;
        end
    end
    
    methods( Access = private, Hidden = true )
        function [obj] = importFromWorkspace(obj,varargin)
            obj.deleteMeshPatch();
            prompt = {'Enter Workspace name:',...
                      'Enter Vertices name:',...
                      'Enter Normals name:',...
                      'Enter UVs name:',...
                      'Enter Faces name:'};
            title = 'Import from Workspace...';
            dims = [1 35];
            definput = {'base','P','N','','T'};
            input = inputdlg(prompt,title,dims,definput);
            if(~isempty(input))
                obj.Output.Vertex = evalin(input{1},input{2});
                obj.Output.Normal = evalin(input{1},input{3});
                if(isempty(input{4}))
                    obj.Output.UV = zeros(row(obj.Output.Vertex),2);
                else
                    obj.Output.UV = evalin(input{1},input{4});
                end
                obj.Output.Face   = evalin(input{1},input{5});
                obj.createMeshPatch();
            end
        end
        
        function [obj] = importFromFile(obj,varargin)
            obj.deleteMeshPatch();
            filter = {'*.obj', 'Wavefront OBJ format'; ...
                      '*.off', 'Object File Format'};
            [name,path,idx] = uigetfile(filter,...
                                        'Import from file...',...
                                        '',...
                                        'MultiSelect','off');
            if( name ~= 0 )
                name     = cell2mat(strrep(name,strrep(filter(idx,1),'*',''),''));
                filename = strcat(path,name);
                switch( idx )
                    case 1
                        [P,N,UV,T] = import_OBJ(filename);
                    case 2
                        [P,N,UV,T] = import_OFF(filename);
                end
                obj.Output.Vertex = P;
                obj.Output.Normal = N;
                obj.Output.UV     = UV;
                obj.Output.Face   = T;
                obj.createMeshPatch();
            end
        end
        
        function [obj] = createMeshPatch(obj)
            obj.Output.Handle = patch('Faces',obj.Output.Face,...
                                     'Vertices',obj.Output.Vertex,...
                                     'VertexNormals',obj.Output.Normal,...
                                     'AmbientStrength',          0.3,...
                                     'DiffuseStrength',          0.6,...
                                     'SpecularStrength',         0.3,...
                                     'SpecularColorReflectance', 0.5,...
                                     'SpecularExponent',         100,...
                                     'BackFaceLighting',         'lit');
            DisplayFace(obj.Output.Handle,[1 1 1]);
            DisplaySmoothShading(obj.Output.Handle);
            DisplayOpaque(obj.Output.Handle);
        end
        
        function [obj] = deleteMeshPatch(obj)
            delete(obj.Output.Handle);
            obj.Output.Handle = [];
        end

    end
end