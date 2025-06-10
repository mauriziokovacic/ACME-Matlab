classdef ModelViewerTool < ViewerTool
    methods( Access = public, Sealed = true )
        function [obj] = ModelViewerTool(varargin)
            obj@ViewerTool(varargin{:});
            setTitle(obj,'Model Viewer Tool');
            setConsoleText(obj,['\textbf{Vertex}: ',num2str(obj.Parent.Mesh.nVertex()),'\quad',...
                                '\textbf{Edge}  : ',num2str(obj.Parent.Mesh.nEdge()),'\quad',...
                                '\textbf{Face}  : ',num2str(obj.Parent.Mesh.nFace()),'\quad',...
                                '\textbf{Volume}: ',num2str(obj.Parent.Mesh.nHedra())]);
            CreateMenu(obj);
        end
    end
    
    methods( Access = public )
        function [h] = showObject(obj)
            h = obj.Parent.Mesh.show();
        end
        
        function registerProps(obj)
            addProps(obj,'Mesh');
        end
        
        function exportData(obj)
            M      = getProps(obj,'Mesh');
            filter = {'*.obj', 'Wavefront OBJ format'; ...
                      '*.off', 'Object File Format';...
                      '*.ply', 'PoLYgon file format'};
            [name,path,idx] = uiputfile(filter,...
                                        'Export Mesh...',...
                                        'Untitled.obj');
            if( name ~= 0 )
                name     = cell2mat(strrep(name,strrep(filter(idx,1),'*',''),''));
                filename = strcat(path,name);
                M.save(filename);
            end
        end
    end
    
    methods( Access = protected, Hidden = true )
        function CreateMenu(obj)
            menu = uimenu(obj.FigureHandle,'Text','File');
            uimenu(menu,'Text','Export...','MenuSelectedFcn',@(varargin) exportData(obj));
            uimenu(menu,'Text','Exit','MenuSelectedFcn',@(varargin) close(obj.FigureHandle));
            h = obj.ObjectHandle;
            menu = uimenu(obj.FigureHandle,'Text','Render');
            sub  = uimenu(menu,'Text','Entity');
            uimenu(sub,'Text','Point',    'MenuSelectedFcn',@(varargin) DisplayPoints(h));
            uimenu(sub,'Text','Wireframe','MenuSelectedFcn',@(varargin) DisplayWireframe(h));
            uimenu(sub,'Text','Wired',    'MenuSelectedFcn',@(varargin) DisplayWired(h));
            uimenu(sub,'Text','Solid',    'MenuSelectedFcn',@(varargin) DisplayFace(h));
            sub  = uimenu(menu,'Text','Shading');
            uimenu(sub,'Text','None',     'MenuSelectedFcn',@(varargin) DisplayNoShading(h));
            uimenu(sub,'Text','Flat',     'MenuSelectedFcn',@(varargin) DisplayFlatShading(h));
            uimenu(sub,'Text','Smooth',   'MenuSelectedFcn',@(varargin) DisplaySmoothShading(h));
            CreateMenu@ViewerTool(obj);
        end
    end
end