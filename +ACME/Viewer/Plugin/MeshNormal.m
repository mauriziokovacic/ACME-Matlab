classdef MeshNormal < Plugin
    properties
        VN = [];
        FN = [];
    end
    
    methods
        function [obj] = createUserInterface(obj)
            menu  = obj.Parent.getMenu('View');
            mitem = [obj.UI;uimenu(menu,'Text','Vertex Normal','Checked','off','Tag','v')];
            mitem.MenuSelectedFcn = @obj.eval;
            mitem = [obj.UI;uimenu(menu,'Text','Face   Normal','Checked','off','Tag','f')];
            mitem.MenuSelectedFcn = @obj.eval;
            
            menu  = obj.Parent.getContextMenu('View');    
            mitem = [obj.UI;uimenu(menu,'Text','Vertex Normal','Checked','off','Tag','v')];
            mitem.MenuSelectedFcn = @obj.eval;
            mitem = [obj.UI;uimenu(menu,'Text','Face   Normal','Checked','off','Tag','f')];
            mitem.MenuSelectedFcn = @obj.eval;
        end
        
        
        function [obj] = eval(obj,varargin)
            m = varargin{1};
            if(strcmpi(m.Checked,'off'))
                m.Checked = 'on';
                h = obj.Parent.getMesh();
                p = [];
                n = [];
                hold on;
                if( strcmpi(m.Tag,'v') )
                    for i = 1 : numel(h)
                        p = [p;h.Vertices];
                        n = [n;h.VertexNormals];
                    end
                    
                    obj.VN = quiv3(p,normr(n),'Color','r');
                else
                    for i = 1 : numel(h)
                        p = [p;triangle_barycenter(h.Vertices,h.Faces)];
                        n = [n;triangle_normal(h.Vertices,h.Faces)];
                    end
                    obj.FN = quiv3(p,normr(n),'Color','b');
                end
                hold off;
            else
                m.Checked = 'off';
                if( strcmpi(m.Tag,'v') )
                    delete(obj.VN);
                    obj.VN = [];
                else
                    delete(obj.FN);
                    obj.FN = [];
                end
            end
        end
    end
end