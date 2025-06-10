classdef ContactPlugin < AbstractPainterPlugin
    properties
    end
    
    methods
        function [obj] = connectProgramData(obj,~)
            obj.buildInputData('MeshData');
            obj.buildOutputData('ContactData',{'W','R','S','C'});
        end
        
        function [obj] = createUserInterface(obj,program)
            obj.buildStandardMenu(program,'Contact');
        end
        
        function BrushVertex(obj)
        end
        
        function updateGraphics(obj)
            S = meandering_triangle(obj.Input.Face,obj.Output.W);
            A = [];
            B = [];
            for i = 1  : row(S)
                if(isempty(S{i}))
                    continue;
                end
                A = [A;from_barycentric(obj.Input.Vertex,obj.Input.Face,S{i}.T,S{i}.A)];
                B = [B;from_barycentric(obj.Input.Vertex,obj.Input.Face,S{i}.T,S{i}.B)];
            end
            hold on;
            line3([A B],'Color','r','LineWidth',2);
        end
        
    end
    
    methods( Access = protected )
        function importFromWorkspace(obj,varargin)
            prompt = {'Enter Workspace name:',...
                      'Enter Weights name:'};
            title = 'Import Contact Data from Workspace...';
            dims = [1 35];
            definput = {'base','W'};
            input = inputdlg(prompt,title,dims,definput);
            if(~isempty(input))
                obj.Output.W = evalin(input{1},input{2});
                obj.updateGraphics();
            end
        end
        
        function importFromFile(obj,varargin)
            filter = {'*.skn', 'Custom Skinning SKN format'};
            [name,path,idx] = uigetfile(filter,...
                                        'Import from file...',...
                                        '',...
                                        'MultiSelect','off');
            if( name ~= 0 )
                name     = cell2mat(strrep(name,strrep(filter(idx,1),'*',''),''));
                filename = strcat(path,name);
                switch( idx )
                    case 1
                        [W] = import_SKN(filename);
                end
                obj.Output.W = W;
                obj.updateGraphics();
            end         
        end
    end
end