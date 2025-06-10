classdef SkeletonPickerTool < PickerTool
    properties
        GraphMode
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = SkeletonPickerTool(varargin)
            obj@PickerTool(varargin{:});
            setTitle(obj,'Skeleton Selection Tool');
            set(obj.ObjectHandle,'ButtonDownFcn',@(o,e) selectBone(obj,o));
            obj.GraphMode = 'node';
            CreateMenu(obj);
        end
        
        function toggleGraphNode(obj)
            obj.GraphMode = 'node';
        end
        
        function toggleGraphHier(obj)
            obj.GraphMode = 'hier';
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            addProps(obj,'Skel');
            addProps(obj,'HandleIndex');
        end
        
        function [h] = showObject(obj)
            h = obj.Parent.Skel.show();
        end
    end
    
    methods
        function selectBone(obj,bone)
            H = getProps(obj,'HandleIndex');
            i = bone.UserData;
            if(strcmpi(obj.GraphMode,'hier'))
                i = subtree(obj.Parent.Skel.Graph,i);
            end
            H = selectObject(obj,H,i);
            setProps(obj,'HandleIndex',H);
            set(obj.ObjectHandle,'FaceColor',White(),'EdgeColor','k','LineWidth',0.5);
            i = ismember(cell2mat(get(obj.ObjectHandle,'UserData')),H);
            set(obj.ObjectHandle(i),'FaceColor',Red()*0.7,'EdgeColor',Red(),'LineWidth',2);
        end
    end
    
    
    methods( Access = protected, Hidden = true )
        function CreateMenu(obj)
            menu = uimenu(obj.FigureHandle,'Text','Selection');
            uimenu(menu,'Text','Node',     'MenuSelectedFcn',@(varargin) toggleGraphNode(obj));
            uimenu(menu,'Text','Hierarchy','MenuSelectedFcn',@(varargin) toggleGraphHier(obj));
        end
    end
    
    methods( Static )
        function [obj] = standAlone(varargin)
            parser = inputParser;
            addRequired( parser, 'Mesh', @(data) isa(data,'AbstractMesh'));
            addRequired( parser, 'Skin', @(data) isa(data,'AbstractSkin'));
            addRequired( parser, 'Skel', @(data) isa(data,'BaseSkeleton'));
            parse(parser,varargin{:});
            h   = SharedDataSystem('Mesh',parser.Results.Mesh,...
                                   'Skin',parser.Results.Skin,...
                                   'Skel',parser.Results.Skel);
            obj = SkeletonPickerTool(h);
        end
    end
end