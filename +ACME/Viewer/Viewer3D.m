classdef Viewer3D < handle
    properties( Access = public )
        BlockMouseEvent = false
        BlockKeyEvent   = false
    end
    
    properties( Access = private , Hidden = true )
        FigureHandle;
        PluginList;
    end
    
    methods
        function [obj] = Viewer3D(varargin)
            obj.FigureHandle = figure('Name','Viewer 3D',...
                                      'NumberTitle','off',...
                                      'MenuBar', 'none',...
                                      'ToolBar','none',...
                                      varargin{:});
            ax = CreateAxes3D(obj.FigureHandle);
            m  = uicontextmenu(obj.FigureHandle);
            obj.FigureHandle.UIContextMenu = m;
            obj.PluginList   = cell(0,1);
            obj.insertPlugin(obj.getStaticPlugin());
            obj.CreateEventConnections();
        end
        
        function [h] = getAxes(obj)
            h = get_axes(obj.FigureHandle);
        end
        
        function [h] = getMenu(obj,text)
            menu = get_menu(obj.FigureHandle);
            i    = find(arrayfun(@(m) strcmpi(m.Text,text),menu),1);
            if( isempty(i) )
                h = uimenu(obj.FigureHandle,'Text',text);
            else
                h = menu(i);
            end
        end
        
        function [h] = getContextMenu(obj,text)
            menu = get_menu(obj.FigureHandle.UIContextMenu);
            i    = find(arrayfun(@(m) strcmpi(m.Text,text),menu),1);
            if( isempty(i) )
                h = uimenu(obj.FigureHandle.UIContextMenu,'Text',text);
            else
                h = menu(i);
            end
        end
        
        function [h] = getMesh(obj)
            h = get_patch(obj.FigureHandle);
        end
        
        function [pluginIdentifier] = insertPlugin(obj,plugin)
            pluginIdentifier = zeros(row(plugin),1);
            for i = 1 : numel(plugin)
                plugin{i}.Parent    = obj;
                obj.PluginList      = [obj.PluginList;{plugin{i}}];
                pluginIdentifier(i) = row(obj.PluginList);
                disp(['Plugin ', class(plugin{i}), ' correctly inserted.']);
            end
            obj.bindPlugin(pluginIdentifier);
        end
        
        function [obj] = removePlugin(obj,pluginIdentifier)
            pluginIdentifier = obj.getPluginIdentifier(pluginIdentifier);
            if(~isempty(pluginIdentifier))
                for i = 1 : numel(pluginIdentifier)
                    obj.unbindPlugin(pluginIdentifier(i));
                    disp(['Plugin ', class(obj.PluginList{pluginIdentifier(i)}), ' correctly removed.']);
                    obj.PluginList(pluginIdentifier) = [];
                end
            end
        end
        
        function [plugin] = getPlugin(obj,pluginIdentifier)
            pluginIdentifier = obj.getPluginIdentifier(pluginIdentifier);
            plugin = obj.PluginList{pluginIdentifier};
        end
    end
    
    methods( Access = private, Hidden = true )
        function [pluginIdentifier] = getPluginIdentifier(obj,pluginIdentifier)
            if(isstring(pluginIdentifier)||ischar(pluginIdentifier))
                for i = 1 : numel(obj.PluginList)
                    if( strcmpi(class(obj.PluginList{i}),pluginIdentifier) )
                        pluginIdentifier = i;
                        break;
                    end
                end
                if(isstring(pluginIdentifier)||ischar(pluginIdentifier))
                        pluginIdentifier = [];
                end
            else
                if( (pluginIdentifier < 1) || (pluginIdentifier > numel(obj.PluginList)) )
                    pluginIdentifier = [];
                end
            end
        end
        
        function [obj] = bindPlugin(obj,pluginIdentifier)
            for n = 1 : numel(pluginIdentifier)
                i = pluginIdentifier(n);
                obj.PluginList{i}.createUserInterface();
            end
        end
        
        function [obj] = unbindPlugin(obj,pluginIdentifier)
            for n = 1 : numel(pluginIdentifier)
                i = pluginIdentifier(n);
                obj.PluginList{i}.deleteUserInterface();
            end 
        end
        
        function [plugin] = getStaticPlugin(obj)
            plugin = [];
            name = dir('Viewer/Plugin/*.m');
            if( ~isempty(name) )
                name   = extractfield(name,'name');
                name   = cellfun(@(txt) strrep(txt,'.m',''), name,'UniformOutput',false);
                plugin = cellfun(@(txt) eval(strcat(txt,'()')), name, 'UniformOutput', false);
                plugin = plugin(cellfun(@(data) isa(data,'Plugin'),plugin));
            end
        end
        
        function [obj] = MouseEventMove(obj,source,event)
            if( obj.BlockMouseEvent ) return; end
            for i = 1 : numel(obj.PluginList)
                obj.PluginList{i}.MouseEventMove(source,event);
            end
        end
        
        function [obj] = MouseEventClick(obj,source,event)
            if( obj.BlockMouseEvent ) return; end
            for i = 1 : numel(obj.PluginList)
                obj.PluginList{i}.MouseEventClick(source,event);
            end
        end
        
        function [obj] = MouseEventRelease(obj,source,event)
            if( obj.BlockMouseEvent ) return; end
            for i = 1 : numel(obj.PluginList)
                obj.PluginList{i}.MouseEventRelease(source,event);
            end
        end
        
        function [obj] = MouseEventWheel(obj,source,event)
            if( obj.BlockMouseEvent ) return; end
            for i = 1 : numel(obj.PluginList)
                obj.PluginList{i}.MouseEventWheel(source,event);
            end
        end
        
        function [obj] = KeyEventPress(obj,source,event)
            if( obj.BlockKeyEvent ) return; end
            for i = 1 : numel(obj.PluginList)
                obj.PluginList{i}.KeyEventPress(source,event);
            end
        end
        
        function [obj] = KeyEventRelease(obj,source,event)
            if( obj.BlockKeyEvent ) return; end
            for i = 1 : numel(obj.PluginList)
                obj.PluginList{i}.KeyEventRelease(source,event);
            end
        end
        
        function [obj] = CreateEventConnections(obj)
            obj.FigureHandle.WindowButtonDownFcn   = @obj.MouseEventClick;
            obj.FigureHandle.WindowButtonUpFcn     = @obj.MouseEventRelease;
            obj.FigureHandle.WindowButtonMotionFcn = @obj.MouseEventMove;
            obj.FigureHandle.WindowScrollWheelFcn  = @obj.MouseEventWheel;
            obj.FigureHandle.WindowKeyPressFcn     = @obj.KeyEventPress;
            obj.FigureHandle.WindowKeyReleaseFcn   = @obj.KeyEventRelease;
        end
    end
end