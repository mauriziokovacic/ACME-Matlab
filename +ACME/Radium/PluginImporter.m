classdef PluginImporter < AbstractPlugin
    methods
        function [obj] = PluginImporter(varargin)
            obj@AbstractPlugin(varargin{:});
        end
        
        function [obj] = createUserInterface(obj,program)
            menu  = program.getMenu('Plugin');
            mitem = uimenu(menu,'Text','Import Plugin...');
            mitem.MenuSelectedFcn = @obj.eval;
        end
        
        
        function [obj] = eval(obj,varargin)
            [filename] = uigetfile('*.m','Load Plugin...','MultiSelect','on');
            if( ~isequal(filename,0) )
                filename = cellfun(@(txt) strrep(txt,'.m',''),cellstr(filename),'UniformOutput',false);
                plugin   = cellfun(@(txt) eval(strcat(txt,'()')), filename, 'UniformOutput', false);
                plugin   = plugin(cellfun(@(data) isa(data,'Plugin'),plugin));
                if( ~isempty(plugin) )
                    obj.Parent.registerPlugin(plugin);
                end
            end
        end
    end
end