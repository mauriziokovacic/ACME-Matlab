classdef BackgroundPlugin < AbstractPlugin
    properties
        AxesHandle
    end
    
    methods
        function [obj] = BackgroundPlugin(varargin)
            obj@AbstractPlugin(varargin{:});
        end
        
        function [obj] = connectProgramData(obj,program)
            obj.AxesHandle = CreateBackgroundAxes3D(program.FigureHandle);
        end
        
        function [obj] = createUserInterface(obj,program)
            menu  = program.getMenu('Background');
            mitem = uimenu(menu,'Text','Off');
            mitem.MenuSelectedFcn = @obj.selectNone;
            mitem = uimenu(menu,'Text','Flat');
            mitem.MenuSelectedFcn = @obj.selectFlat;
            mitem = uimenu(menu,'Text','Linear');
            mitem.MenuSelectedFcn = @obj.selectLinear;
            mitem = uimenu(menu,'Text','Radial');
            mitem.MenuSelectedFcn = @obj.selectRadial;
        end
    end
    
    methods( Access = private, Hidden = true )
        function [obj] = selectNone(obj,varargin)
            delete(obj.AxesHandle.Children);
        end
        
        function [obj] = selectFlat(obj,varargin)
            delete(obj.AxesHandle.Children);
            X = [0, 1, 1, 0];
            Y = [0, 0, 1, 1];
            patch(X, Y, Y,...
                'Parent', obj.AxesHandle,...
                'FaceColor',[1 1 1],...
                'EdgeColor','none');
        end
        
        function [obj] = selectLinear(obj,varargin)
            delete(obj.AxesHandle.Children);
            CData = [0.6 0.6 0.6; 1 1 1];
            X = [0, 1, 1, 0];
            Y = [0, 0, 1, 1];
            patch(X, Y, Y,...
                'Parent', obj.AxesHandle,...
                'FaceColor','interp',...
                'FaceVertexCData',repelem(CData,2,1),...
                'EdgeColor','none');
        end
        
        function [obj] = selectRadial(obj,varargin)
            delete(obj.AxesHandle.Children);
            CData = [1 1 1; 0.6 0.6 0.6];
            [X,Y] = meshgrid(linspace(-1,1,128));
            C = clamp(arrayfun(@(x,y) norm([x y]), X, Y),0,1);
            C = interp1([0 1],CData,C);
            imagesc(obj.AxesHandle,C,'XData',[0,1],'YData',[0,1]);
        end
    end
end