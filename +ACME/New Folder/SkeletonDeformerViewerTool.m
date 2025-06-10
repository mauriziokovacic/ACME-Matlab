classdef SkeletonDeformerViewerTool < ModelViewerTool
    properties( Access = public, SetObservable )
        Deformer
    end
    
    properties( Access = protected, Hidden = true )
        skelListener
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = SkeletonDeformerViewerTool(varargin)
            obj@ModelViewerTool(varargin{:});
            setTitle(obj,'Deformer Viewer Tool');
%             parser = inputParser;
%             parser.KeepUnmatched = true;
%             addParameter( parser, 'Deformer',[],@(data) isa(data,'AbstractDeformer'));
%             parse(parser,varargin{:});
%             name = fieldnames(parser.Results);
%             for i = 1 : numel(name)
%                 obj.(name{i}) = parser.Results.(name{i});
%             end
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            addProps(obj,'Mesh');
            addProps(obj,'Skin');
            addProps(obj,'Skel');
            obj.skelListener = addlistener(obj.Parent.Skel,'PoseChanged',@(varargin) deform(obj));
        end
        
        function delete(obj)
            delete(obj.skelListener);
        end
        
        function deform(obj)
            H    = getProps(obj,'Skel');
            Pose = mat2lin(relativePose(H));
            [obj.ObjectHandle.Vertices,obj.ObjectHandle.VertexNormals] = obj.Deformer.deform(Pose);
        end
    end
    
    methods( Access = public, Static )
        function [obj] = LBSTool(Parent)
            obj = SkeletonDeformerViewerTool(Parent);
            setTitle(obj,'Linear Blend Skinning Viewer Tool');
            obj.Deformer = LBSDeformer('Mesh',obj.Parent.Mesh,'Skin',obj.Parent.Skin);
        end
        
        function [obj] = DQSTool(Parent)
            obj = SkeletonDeformerViewerTool(Parent);
            setTitle(obj,'Dual Quaternion Skinning Viewer Tool');
            obj.Deformer = DQSDeformer('Mesh',obj.Parent.Mesh,'Skin',obj.Parent.Skin);
        end
        
        function [obj] = CORTool(Parent,CoR)
            obj = SkeletonDeformerViewerTool(Parent);
            setTitle(obj,'Optimized Center of Rotation Skinning Viewer Tool');
            obj.Deformer = CORDeformer('Mesh',obj.Parent.Mesh,'Skin',obj.Parent.Skin,'CoR',CoR);
        end
    end
end