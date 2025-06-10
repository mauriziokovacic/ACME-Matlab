classdef CageInfluencerViewerTool < HandleInfluencerViewerTool
    methods( Access = public, Sealed = true )
        function [obj] = CageInfluencerViewerTool(varargin)
            obj@HandleInfluencerViewerTool(varargin{:});
            setTitle(obj,'Cage Influencer Viewer Tool');
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            registerProps@HandleInfluencerViewerTool(obj);
            addProps(obj,'Cage');
        end
        
        function [h] = showObject(obj)
            h = obj.Parent.Cage.show();
        end
    end
    
    methods( Access = protected )
        function resetObjectStatus(obj)
            set(obj.ObjectHandle,'FaceColor','none','EdgeColor','k');
        end
        
        function updateObjectStatus(obj,j)
            C     = zeros(obj.Parent.Cage.nVertex(),3);
            C(j,:)= repmat(Red(),numel(j),1);
            set(obj.ObjectHandle,'FaceColor','none','EdgeColor','interp','FaceVertexCData',C);
        end
    end
    
    methods( Static )
        function [obj] = standAlone(varargin)
            parser = inputParser;
            addRequired( parser, 'Mesh', @(data) isa(data,'AbstractMesh'));
            addRequired( parser, 'Skin', @(data) isa(data,'AbstractSkin'));
            addRequired( parser, 'Cage', @(data) isa(data,'AbstractCage'));
            parse(parser,varargin{:});
            h   = SharedDataSystem('Mesh',parser.Results.Mesh,...
                                   'Skin',parser.Results.Skin,...
                                   'Cage',parser.Resutls.Cage);
            obj = CageInfluencerViewerTool(h);
        end
    end
end