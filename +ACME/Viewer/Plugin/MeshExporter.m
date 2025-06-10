classdef MeshExporter < Plugin
    methods
        function [obj] = createUserInterface(obj)
            menu  = obj.Parent.getMenu('File');
            mitem = [obj.UI;uimenu(menu,'Text','&Export Mesh...')];
            mitem.MenuSelectedFcn = @obj.eval;
            
            menu  = obj.Parent.getContextMenu('File');
            mitem = [obj.UI;uimenu(menu,'Text','&Export Mesh...')];
            mitem.MenuSelectedFcn = @obj.eval;
        end
        
        
        function [obj] = eval(obj,varargin)
            persistent filter;
            if(isempty(filter))
                filter = {'*.obj', 'Wavefront OBJ format'; ...
                          '*.off', 'Object File Format'};
            end
            
            [name,path,idx] = uiputfile(filter,...
                                        'Export Mesh...',...
                                        'Untitled.obj');
            if( name ~= 0 )
                name     = cell2mat(strrep(name,strrep(filter(idx,1),'*',''),''));
                filename = strcat(path,name);
                
                h  = obj.Parent.getMesh(object);
                for i = 1 : numel(h)
                    if( numel(h) == 1 )
                        suffix = '';
                    else
                        suffix = strcat('_',num2str(i));
                    end
                    P  = h(i).Vertices;
                    T  = h(i).Faces;
                    switch( idx )
                        case 1
                            N  = h(i).VertexNormals;
                            UV = zeros(row(P),2);
                            export_OBJ( strcat(filename,suffix), P, N, UV, T );
                        case 2
                            export_OFF( strcat(filename,suffix), P, T );
                        otherwise
                            continue;
                    end
                end
            end
        end
    end
end