classdef PickerTool < ViewerTool
    properties( Access = protected, Hidden = true )
        SelectionMode
        AlternateSelection
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = PickerTool(varargin)
            obj@ViewerTool(varargin{:});
            setTitle(obj,'Selection Tool');
            obj.SelectionMode      = 'unique';
            obj.AlternateSelection = false;
            setConsoleText(obj,['\textbf{Selection Mode}: ',obj.SelectionMode,'\quad \textit{(press s to change)}']);
        end
    end

    methods( Access = public )
        function EventKeyPress(obj,~,event)
            switch event.Key
                case 's'
                    if(strcmpi(obj.SelectionMode,'unique'))
                        obj.SelectionMode = 'multiple';
                    else
                        obj.SelectionMode = 'unique';
                    end
                case 'control'
                    obj.AlternateSelection = true;
            end
            setConsoleText(obj,['\textbf{Selection Mode}: ',obj.SelectionMode,'\quad \textit{(press s to change)}']);
        end
        
        function EventKeyRelease(obj,~,event)
            switch event.Key
                case 'control'
                    obj.AlternateSelection = false;
            end
        end
    end
    
    methods( Access = protected )
        function [tf] = isSelectionAlternate(obj)
            tf = obj.AlternateSelection;
        end
        
        function [tf] = isSelectionUnique(obj)
            tf = strcmpi(obj.SelectionMode,'unique');
        end
        
        function [tf] = isSelectionMultiple(obj)
            tf = strcmpi(obj.SelectionMode,'multiple');
        end
        
%         function [I] = selectObject(obj,I,i)
%             if(ismember(i,I))
%                 if(strcmpi(obj.SelectionMode,'unique'))
%                     I = [];
%                 else
%                     I = setdiff(I,i,'stable');
%                 end
%             else
%                 if(strcmpi(obj.SelectionMode,'unique'))
%                     I = [];
%                 end
%                 I = [I;i];
%             end
%         end
        
        function [I,varargout] = selectObject(obj,I,i,varargin)
            if(nargin<4)
                S = false(size(I));
            else
                S = varargin{1};
            end
            k = find(ismember(I,i),1);
            if(isempty(k))
                if(isSelectionUnique(obj))
                    I = [];
                    S = [];
                end
                I = [I;i];
                S = [S;isSelectionAlternate(obj)];
            else
                if(isSelectionUnique(obj))
                    if(numel(I)>1)
                        I = i;
                        S = ~(isSelectionAlternate(obj)==S(k));
                    else
                        if(isSelectionAlternate(obj)==S(k))
                            I = [];
                            S = [];
                        else
                            S = ~S;
                        end
                    end
                else
                    if(isSelectionAlternate(obj)==S(k))
                        I(k) = [];
                        S(k) = [];
                    else
                        S(k) = ~S(k);
                    end
                end
            end
            if(nargout>=2)
                varargout{1} = logical(S);
            end
        end
    end
end