classdef CageViewerTool < ViewerTool
    methods( Access = public, Sealed = true )
        function [obj] = CageViewerTool(varargin)
            obj@ViewerTool(varargin{:});
            setTitle(obj,'Cage Viewer Tool');
            registerProps(obj);
            setConsoleText(obj,['\textbf{Vertex}: ',num2str(obj.Parent.Cage.nVertex()),'\quad',...
                                '\textbf{Edge}  : ',num2str(obj.Parent.Cage.nEdge()),'\quad',...
                                '\textbf{Face}  : ',num2str(obj.Parent.Cage.nFace()),'\quad',...
                                '\textbf{Volume}: ',num2str(obj.Parent.Cage.nHedra())]);
        end
    end
    
    methods( Access = public )
        function [h] = showObject(obj)
            h = obj.Parent.Cage.show();
        end
        
        function registerProps(obj)
            addProps(obj,'Cage');
        end
    end

    methods( Static )
        function [obj] = standAlone(varargin)
            parser = inputParser;
            addRequired( parser, 'Cage', @(data) isa(data,'AbstractCage'));
            parse(parser,varargin{:});
            h   = SharedDataSystem('Cage',parser.Results.Cage);
            obj = CageViewerTool(h);
        end
    end
end