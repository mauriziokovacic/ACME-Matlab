classdef MeshExporterPlugin < AbstractPlugin
    methods
        function [obj] = MeshExporterPlugin(varargin)
            obj@AbstractPlugin(varargin{:});
        end
        
        function [obj] = connectProgramData(obj,program)
            obj.Input = program.getData('MeshData');
        end
        
        function [obj] = createUserInterface(obj,program)
            menu  = program.getMenu('File');
            menu = uimenu(menu,'Text','Export');
            mitem = uimenu(menu,'Text','To Workspace...');
            mitem.MenuSelectedFcn = @obj.exportToWorkspace;
            mitem = uimenu(menu,'Text','To file...');
            mitem.MenuSelectedFcn = @obj.exportToFile;
        end
    end
    
    methods( Access = private, Hidden = true )
        function [obj] = exportToWorkspace(obj,varargin)
            prompt = {'Enter Workspace name:',...
                      'Enter Vertices name:',...
                      'Enter Normals name:',...
                      'Enter UVs name:',...
                      'Enter Faces name:'};
            title = 'Export to Workspace...';
            dims = [1 35];
            definput = {'base','P','N','UV','T'};
            input = inputdlg(prompt,title,dims,definput);
            assignin(input{1},input{2},obj.Input.Vertex);
            assignin(input{1},input{3},obj.Input.Normal);
            assignin(input{1},input{4},obj.Input.UV);
            assignin(input{1},input{5},obj.v.Face);
        end
        
        function [obj] = exportToFile(obj,varargin)
            filter = {'*.obj', 'Wavefront OBJ format'; ...
                      '*.off', 'Object File Format'};
            [name,path,idx] = uiputfile(filter,...
                                        'Export to file...',...
                                        'Untitled.obj');
            if( name ~= 0 )
                name     = cell2mat(strrep(name,strrep(filter(idx,1),'*',''),''));
                filename = strcat(path,name);
                P  = obj.v.Vertex;
                T  = obj.Input.Face;
                switch( idx )
                    case 1
                        N  = obj.Input.Normal;
                        UV = obj.Input.UV;
                        export_OBJ(filename, P, N, UV, T );
                    case 2
                        export_OFF(filename, P, T );
                end
            end
        end
    end
end