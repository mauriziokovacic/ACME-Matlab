classdef DataImporterPlugin < AbstractPlugin
    methods
        function [obj] = createUserInterface(obj,program)
            uimenu(program.getMenu('Painters'),'Text','Load Contact Data',...
                   'MenuSelectedFcn',@obj.loadContactData);
            uimenu(program.getMenu('Painters'),'Text','Save Contact Data',...
                   'MenuSelectedFcn',@obj.saveContactData);
        end
        
        function loadContactData(obj,varargin)
            obj.buildOutputData('SkinData','Value');
            obj.Output.Value = evalin('base','W');
            data = obj.Parent.getData('WeightPainterData');
            data.Value = evalin('base','U');
            data = obj.Parent.getData('PositionPainterData');
            data.Value = evalin('base','P_');
            data = obj.Parent.getData('NormalPainterData');
            data.Value = evalin('base','N_');
        end
        
        function saveContactData(obj,varargin)
%             data = obj.Parent.getData('SkinData');
%             assignin('base','W',data.Value);
            data = obj.Parent.getData('WeightPainterData');
            assignin('base','U',data.Value);
            data = obj.Parent.getData('PositionPainterData');
            assignin('base','P_',data.Value);
            data = obj.Parent.getData('NormalPainterData');
            assignin('base','N_',data.Value);
        end
    end
end