classdef Viewer < handle
    properties( Access = public, SetObservable )
        Data
    end
    
    properties( Access = public )
        FigureHandle
        AxesHandle
    end
    
    properties( Access = private, Hidden = true )
        PluginList    = [];
        ActivePlugin  = [];
        DefaultPlugin = [];
        
        InterCatcher;
        KeyHandler;
        MouseHandler;
    end
    
    events
        ViewerSizeChanged
        ViewerDataChanged
    end
    
    methods( Access = public )
        function [obj,data] = Viewer(varargin)
            obj.FigureHandle = figure('Name','Viewer 3D',...
                                      'NumberTitle','off',...
                                      'MenuBar', 'none',...
                                      'ToolBar','none');
            obj.AxesHandle = CreateAxes3D(obj.FigureHandle);
            hold(obj.AxesHandle,'on');

            obj.Data = ViewerData();
            obj.PluginList = cell(0,1);
            addlistener(obj,'Data','PostSet',@obj.EventDataChanged);
            
            obj.InterCatcher = InteractionEventCatcher(obj.FigureHandle);
            obj.KeyHandler   = KeyEventHandler(obj.InterCatcher);
            obj.MouseHandler = MouseEventHandler(obj.InterCatcher);
            obj.CreateEventConnections();
            
            obj.LoadStaticPlugins();
            
            data = obj.Data;
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
        
        function [h] = getToolBar(obj)
            h = get_toolbar(obj.FigureHandle);
            if( isempty(h) )
                h = uitoolbar(obj.FigureHandle);
            end
        end
        
        function [h] = getData(obj,dataName)
            if(isempty(findprop(obj.Data,dataName)))
                obj.Data.addprop(dataName);
            end
            h = obj.Data.(dataName);
        end
        
        function [out] = setData(obj,dataName,dataValue)
            if(isempty(findprop(obj.Data,dataName)))
                obj.Data.addprop(dataName);
            end
            obj.Data.(dataName) = dataValue;
            out = obj.Data.(dataName);
        end
                
        function [pluginIdentifier] = registerPlugin(obj,plugin)
            pluginIdentifier = [];
            if(numel(plugin)==1)
                if(~iscell(plugin))
                    plugin = {plugin};
                end
            end
            for i = 1 : numel(plugin)
                h = plugin{i};
                if(isa(h,'AbstractPlugin'))
                    obj.PluginList = [obj.PluginList;{h}];
                    pluginIdentifier = [pluginIdentifier;row(obj.PluginList);];
                    obj.bindPlugin(pluginIdentifier(end));
%                     disp(['Plugin ', class(h), ' correctly inserted.']);
                    h.Registered = true;
                end
            end
        end
        
        function [plugin] = getPlugin(obj,pluginIdentifier)
            pluginIdentifier = obj.getPluginIdentifier(pluginIdentifier);
            plugin = obj.PluginList{pluginIdentifier};
        end

    end
    
    methods( Access = private, Hidden = true )
        function [obj] = ActivatePlugin(obj,plugin)
            pluginIdentifier = obj.getPluginIdentifier(class(plugin));
            if(~isempty(pluginIdentifier))
                if(~isempty(obj.ActivePlugin))
                    obj.ActivePlugin.RequestAcknowledge('RequestDeactivation',true,obj);
                end
                obj.ActivePlugin = plugin;
                plugin.RequestAcknowledge('RequestActivation',true,obj);
            else
                plugin.RequestAcknowledge('RequestActivation',false,obj);
            end
        end
        
        function [obj] = DeactivatePlugin(obj,plugin)
            pluginIdentifier = obj.getPluginIdentifier(class(plugin));
            if(~isempty(pluginIdentifier))
                active = obj.getPluginIdentifier(class(obj.ActivePlugin));
                if( active == pluginIdentifier )
                    plugin.RequestAcknowledge('RequestDeactivation',true,obj);
                    obj.ActivePlugin = [];
                else
                    plugin.RequestAcknowledge('RequestDeactivation',false,obj);
                end
            else
                plugin.RequestAcknowledge('RequestDeactivation',false,obj);
            end
        end
        
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
                h = obj.PluginList{i};
                h.Parent = obj;
                h.connectProgramData(obj);
                h.createUserInterface(obj);
                if(isa(h,'AbstractInteractionPlugin'))
                    addlistener(h,'RequestActivation',  @(o,e) obj.ActivatePlugin(o));
                    addlistener(h,'RequestDeactivation',@(o,e) obj.DeactivatePlugin(o));
                end
            end
        end
        
        function [obj] = EventDataChanged(obj,varargin)
            for i = 1 : numel(obj.PluginList)
                obj.PluginList{i}.programDataChanged(obj);
            end
        end
        
        function [obj] = EventInteraction(obj,routineName,source,event)
            if( isempty(obj.ActivePlugin) )
                obj.DefaultPlugin.(routineName)(source,event);
                return;
            end
            if(obj.ActivePlugin.Bypass || obj.ActivePlugin.isStandby())
                obj.DefaultPlugin.(routineName)(source,event);
            end
            if(obj.ActivePlugin.Bypass || ~obj.ActivePlugin.isStandby())
                obj.ActivePlugin.(routineName)(source,event);
            end
        end
        
        function [obj] = EventKeyPress(obj,source,event)
            if( isempty(obj.ActivePlugin) )
                obj.DefaultPlugin.EventKeyPress(source,event);
                return;
            end
            switch event.Key
                case 's'
                    obj.ActivePlugin.RequestAcknowledge('RequestStandby',~obj.ActivePlugin.isStandby(),obj);
                    return;
            end
            if(obj.ActivePlugin.Bypass || obj.ActivePlugin.isStandby())
                obj.DefaultPlugin.EventKeyPress(source,event);
            end
            if(obj.ActivePlugin.Bypass || ~obj.ActivePlugin.isStandby())
                obj.ActivePlugin.EventKeyPress(source,event);
            end
        end
                
        function [obj] = CreateEventConnections(obj)
            obj.FigureHandle.SizeChangedFcn = @(varargin) notify(obj,'ViewerSizeChanged');
            addlistener(obj.KeyHandler,  'EventKeyPress',    @(o,e) obj.EventKeyPress(e.Parent,e));
            addlistener(obj.KeyHandler,  'EventKeyRelease',  @(o,e) obj.EventInteraction('EventKeyRelease',e.Parent,e));
            addlistener(obj.MouseHandler,'EventClick',       @(o,e) obj.EventInteraction('EventMouseClick',e.Parent,e));
            addlistener(obj.MouseHandler,'EventLeftClick',   @(o,e) obj.EventInteraction('EventMouseLeftClick',e.Parent,e));
            addlistener(obj.MouseHandler,'EventWheelClick',  @(o,e) obj.EventInteraction('EventMouseWheelClick',e.Parent,e));
            addlistener(obj.MouseHandler,'EventRightClick',  @(o,e) obj.EventInteraction('EventMouseRightClick',e.Parent,e));
            addlistener(obj.MouseHandler,'EventDoubleClick', @(o,e) obj.EventInteraction('EventMouseDoubleClick',e.Parent,e));
            addlistener(obj.MouseHandler,'EventRelease',     @(o,e) obj.EventInteraction('EventMouseRelease',e.Parent,e));
            addlistener(obj.MouseHandler,'EventLeftRelease', @(o,e) obj.EventInteraction('EventMouseLeftRelease',e.Parent,e));
            addlistener(obj.MouseHandler,'EventWheelRelease',@(o,e) obj.EventInteraction('EventMouseWheelRelease',e.Parent,e));
            addlistener(obj.MouseHandler,'EventRightRelease',@(o,e) obj.EventInteraction('EventMouseRightRelease',e.Parent,e));
            addlistener(obj.MouseHandler,'EventGrab',        @(o,e) obj.EventInteraction('EventMouseGrab',e.Parent,e));
            addlistener(obj.MouseHandler,'EventLeftGrab',    @(o,e) obj.EventInteraction('EventMouseLeftGrab',e.Parent,e));
            addlistener(obj.MouseHandler,'EventWheelGrab',   @(o,e) obj.EventInteraction('EventMouseWheelGrab',e.Parent,e));
            addlistener(obj.MouseHandler,'EventRightGrab',   @(o,e) obj.EventInteraction('EventMouseRightGrab',e.Parent,e));
            addlistener(obj.MouseHandler,'EventMove',        @(o,e) obj.EventInteraction('EventMouseMove',e.Parent,e));
            addlistener(obj.MouseHandler,'EventScroll',      @(o,e) obj.EventInteraction('EventMouseScroll',e.Parent,e));
        end
        
        function [obj] = LoadStaticPlugins(obj)
            name = {'MeshImporterPlugin';...
                    'MeshExporterPlugin';...
                    'VertexPickerPlugin';...
                    'ShaderPlugin';...
                    'CameraPlugin';...
                    'LightPlugin';...
                    'CurvaturePlugin';...
                    'BackgroundPlugin';...
                    'PluginImporter';...
                    'ConsolePlugin';...
                    'WeightPainterPlugin';...
                    'PositionPainterPlugin';...
                    'NormalPainterPlugin';...
                    'DataImporterPlugin';...
                    'ContactViewerPlugin';...
                    'ContactPainterPlugin';...
                    'FoldPainterPlugin'};
            for i = 1 : numel(name)
                plugin = eval(strcat(name{i},'(obj)'));
                obj.registerPlugin(plugin);
            end
            obj.DefaultPlugin = ...
                obj.PluginList{obj.getPluginIdentifier('CameraPlugin')};
        end
        
    end
end