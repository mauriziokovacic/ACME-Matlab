classdef PluginLoader < Plugin
    methods
        function [obj] = createUserInterface(obj)
            menu  = obj.Parent.getMenu('Plugin');
            mitem = [obj.UI;uimenu(menu,'Text','&Import Plugin...')];
            mitem.MenuSelectedFcn = @obj.eval;
        end
        
        
        function [obj] = eval(obj,varargin)
            [filename] = uigetfile('*.m','Load Plugin...','MultiSelect','on');
            if( ~isequal(filename,0) )
                filename = cellfun(@(txt) strrep(txt,'.m',''),cellstr(filename),'UniformOutput',false);
                plugin   = cellfun(@(txt) eval(strcat(txt,'()')), filename, 'UniformOutput', false);
                plugin   = plugin(cellfun(@(data) isa(data,'Plugin'),plugin));
                if( ~isempty(plugin) )
                    obj.Parent.insertPlugin(plugin);
                end
            end
        end
    end
end