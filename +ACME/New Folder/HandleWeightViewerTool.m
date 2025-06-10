classdef HandleWeightViewerTool < ModelViewerTool
    properties( Access = protected, Hidden = true )
        handleListener
        ViewMode
        WeightTexture
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = HandleWeightViewerTool(varargin)
            obj@ModelViewerTool(varargin{:});
            setTitle(obj,'Handle Weight Viewer Tool');
            obj.ObjectHandle.FaceColor       = 'interp';
            obj.ObjectHandle.FaceVertexCData = zeros(row(obj.Parent.Mesh.Vertex),1);
            obj.WeightTexture = 'king';
            caxis([0 1]);
            cmap(obj.WeightTexture,256);
            colorbar(obj.AxesHandle.AxesHandle);
            obj.ViewMode = 'smooth';
            setConsoleText(obj,['\textbf{Selection Mode}: ',obj.ViewMode,'\quad \textit{(press v to change)}']);
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            registerProps@ModelViewerTool(obj);
            addProps(obj,'Skin');
            addProps(obj,'HandleIndex');
            obj.handleListener = addPropListener(obj,...
                                               'HandleIndex',...
                                               @(varargin) selectHandle(obj));
        end
        
        function delete(obj)
            delete(obj.handleListener);
        end
    end
    
    methods( Access = public )
        function EventKeyPress(obj,~,event)
            switch event.Key
                case 'v'
                    if(strcmpi(obj.ViewMode,'discrete'))
                        obj.ViewMode = 'smooth';
                    else
                        obj.ViewMode = 'discrete';
                    end
                    selectHandle(obj);
            end
            setConsoleText(obj,['\textbf{View Mode}: ',obj.ViewMode,'\quad \textit{(press v to change)}']);
        end
        
        function selectHandle(obj)
            M = getProps(obj,'Mesh');
            S = getProps(obj,'Skin');
            H = getProps(obj,'HandleIndex');
            if(isempty(H))
                W = zeros(row(M.Vertex),1);
            else
                W = full(sum(S.Weight(:,H),2));
            end
            obj.ObjectHandle.FaceVertexCData = W;
            if(strcmpi(obj.ViewMode,'discrete'))
                cmap(obj.WeightTexture,10);
            else
                cmap(obj.WeightTexture,256);
            end
        end
    end
    
    methods( Static )
        function [obj] = standAlone(varargin)
            parser = inputParser;
            addRequired( parser, 'Mesh', @(data) isa(data,'AbstractMesh'));
            addRequired( parser, 'Skin', @(data) isa(data,'AbstractSkin'));
            parse(parser,varargin{:});
            h   = SharedDataSystem('Mesh',parser.Results.Mesh,...
                                   'Skin',parser.Results.Skin);
            obj = HandleWeightViewerTool(h);
        end
    end
end