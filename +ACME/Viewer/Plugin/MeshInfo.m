classdef MeshInfo < Plugin
    properties
        Info = [];
    end
    
    methods
        function [obj] = createUserInterface(obj)
            menu = obj.Parent.getMenu('View');
            mitem  = [obj.UI;uimenu(menu,'Text','Mesh Info','Checked','off')];
            mitem.MenuSelectedFcn = @obj.eval;
        end
        
        
        function [obj] = eval(obj,varargin)
            m = varargin{1};
            if(strcmpi(m.Checked,'off'))
                m.Checked = 'on';
                h = obj.Parent.getMesh();
                nP = 0;
                nF = 0;
                for i = 1 : numel(h)
                    nP = nP+row(h.Vertices);
                    nF = nF+row(h.Faces);
                end
                obj.Info = annotation('textbox',...
                    'String',[...
                    '#Meshes   : ', num2str(numel(h)),newline,...
                    '#Vertices : ', num2str(nP),newline,...
                    '#Faces    : ', num2str(nF)],...
                    'Position',[0 0 0.21 0.15],...
                    'FitBoxToText','off');
            else
                m.Checked = 'off';
                delete(obj.Info);
                obj.Info = [];
            end
        end
    end
end