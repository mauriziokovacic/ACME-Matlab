classdef LightPlugin < AbstractPlugin
    properties
        Light
        Type
    end
    
    methods
        function [obj] = LightPlugin(varargin)
            obj@AbstractPlugin(varargin{:});
            obj.Type = 'right';
        end
        
        function [obj] = connectProgramData(obj,program)
            obj.Light = camlight(program.AxesHandle,obj.Type);
            addlistener(program.FigureHandle,'CurrentPoint','PostSet', @obj.update);
            addlistener(program.AxesHandle,'CameraPosition','PostSet', @obj.update);
        end
        
        function [obj] = createUserInterface(obj,program)
            menu  = program.getMenu('Light');
            mitem = uimenu(menu,'Text','Off');
            mitem.MenuSelectedFcn = @obj.selectNone;
            mitem = uimenu(menu,'Text','Headlight');
            mitem.MenuSelectedFcn = @obj.selectHeadlight;
            mitem = uimenu(menu,'Text','Left');
            mitem.MenuSelectedFcn = @obj.selectLeft;
            mitem = uimenu(menu,'Text','Right');
            mitem.MenuSelectedFcn = @obj.selectRight;
        end
    end
    
    methods( Access = private, Hidden = true )
        function [obj] = update(obj,varargin)
            if(strcmpi(obj.Type,'none'))
                obj.Light.Visible = 'off';
            else
                obj.Light = camlight(obj.Light,obj.Type);
                obj.Light.Visible = 'on';
            end
        end
        
        function [obj] = selectNone(obj,varargin)
            obj.Type = 'none';
            obj.update();
        end
        
        function [obj] = selectHeadlight(obj,varargin)
            obj.Type = 'headlight';
            obj.update();
        end
        
        function [obj] = selectRight(obj,varargin)
            obj.Type = 'right';
            obj.update();
        end
        
        function [obj] = selectLeft(obj,varargin)
            obj.Type = 'left';
            obj.update();
        end
    end
end