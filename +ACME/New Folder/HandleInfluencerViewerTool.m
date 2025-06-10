classdef HandleInfluencerViewerTool < ViewerTool
    properties( Access = private, Hidden = true )
        vertexListener
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = HandleInfluencerViewerTool(varargin)
            obj@ViewerTool(varargin{:});
            setTitle(obj,'Handle Influencer Viewer Tool');
            setConsoleText(obj,['\textbf{Weight}: 0',newline,...
                                '\textbf{Index} : []']);
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            addProps(obj,'Skin');
            addProps(obj,'VertexIndex');
            addProps(obj,'HandleIndex');
            obj.vertexListener = addPropListener(obj,'VertexIndex',@(varargin) selectVertex(obj));
        end
        
        function delete(obj)
            delete(obj.vertexListener);
        end
    end
    
    methods( Access = protected )
        function selectVertex(obj)
            V = getProps(obj,'VertexIndex');
            resetObjectStatus(obj);
            setConsoleText(obj,['\textbf{Weight}: 0',newline,...
                                '\textbf{Index} : []']);
            if(isempty(V))
                return;
            end
            W = obj.Parent.Skin.Weight;
            [~,j] = find(W(V,:));
            j = unique(j);
            setProps(obj,'HandleIndex',j);
            setConsoleText(obj,['\textbf{Weight}: ',num2str(numel(j)),newline,...
                                '\textbf{Index} : [ ',num2str(make_row(j),repmat(' %u',1,numel(j))),' ]']);
            updateObjectStatus(obj,j);
        end
    end
    
    methods( Access = protected, Abstract )
        resetObjectStatus(obj)
        updateObjectStatus(obj,j)
    end
end