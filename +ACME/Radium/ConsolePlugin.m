classdef ConsolePlugin < AbstractPlugin
    properties
        AxesHandle
    end
    
    methods
        function [obj] = ConsolePlugin(varargin)
            obj@AbstractPlugin(varargin{:});
        end
        
        function [obj] = connectProgramData(obj,program)
            obj.AxesHandle = CreateForegroundAxes3D(program.FigureHandle);
        end
        
        function [obj] = createUserInterface(obj,program)
            menu  = program.getMenu('Console');
            mitem = uimenu(menu,'Text','Off');
            mitem.MenuSelectedFcn = @obj.selectOff;
            mitem = uimenu(menu,'Text','On');
            mitem.MenuSelectedFcn = @obj.selectOn;
        end
    end
    
    methods( Access = private, Hidden = true )
        function [obj] = selectOff(obj,varargin)
            delete(obj.AxesHandle.Children);
        end
        
        function [obj] = selectOn(obj,varargin)
            delete(obj.AxesHandle.Children);
            
        end
    end
end