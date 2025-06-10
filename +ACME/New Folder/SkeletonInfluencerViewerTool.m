classdef SkeletonInfluencerViewerTool < HandleInfluencerViewerTool
    methods( Access = public, Sealed = true )
        function [obj] = SkeletonInfluencerViewerTool(varargin)
            obj@HandleInfluencerViewerTool(varargin{:});
            setTitle(obj,'Skeleton Influencer Viewer Tool');
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            registerProps@HandleInfluencerViewerTool(obj);
            addProps(obj,'Skel');
        end
        
        function [h] = showObject(obj)
            h = obj.Parent.Skel.show();
        end
    end
    
    methods( Access = protected )
        function resetObjectStatus(obj)
            set(obj.ObjectHandle,'FaceColor',White(),'EdgeColor','k','LineWidth',0.5);
        end
        
        function updateObjectStatus(obj,j)
            i = ismember(cell2mat(get(obj.ObjectHandle,'UserData')),j);
            set(obj.ObjectHandle(i),'FaceColor',Red()*0.7,'EdgeColor',Red(),'LineWidth',2);
        end
    end
    
    methods( Static )
        function [obj] = standAlone(varargin)
            parser = inputParser;
            addRequired( parser, 'Mesh', @(data) isa(data,'AbstractMesh'));
            addRequired( parser, 'Skin', @(data) isa(data,'AbstractSkin'));
            addRequired( parser, 'Skel', @(data) isa(data,'BaseSkeleton'));
            parse(parser,varargin{:});
            h   = SharedDataSystem('Mesh',parser.Results.Mesh,...
                                   'Skin',parser.Results.Skin,...
                                   'Skel',parser.Resutls.Skel);
            obj = SkeletonInfluencerViewerTool(h);
        end
    end
end