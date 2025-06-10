classdef PluginRemover < Plugin
    methods
        function [obj] = createUserInterface(obj)
            menu  = obj.Parent.getMenu('Plugin');
            mitem = [obj.UI;uimenu(menu,'Text','&Remove Plugin...')];
            mitem.MenuSelectedFcn = @obj.eval;
        end
        
        
        function [obj] = eval(obj,varargin)
            pluginIdentifier = inputdlg('Enter plugin name or identifier',...
                              'Remove Plugin');
            pluginIdentifier = pluginIdentifier{1};
            if( ~isnan(str2double(pluginIdentifier)) )
                pluginIdentifier = str2double(pluginIdentifier);
            end
            obj.Parent.removePlugin(pluginIdentifier);
        end
    end
end