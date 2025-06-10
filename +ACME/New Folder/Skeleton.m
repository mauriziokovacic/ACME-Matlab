classdef Skeleton < AbstractHandle
    properties( Access = public, SetObservable )
        Graph
        BoneList
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = Skeleton(varargin)
            obj@AbstractHandle(varargin{:});
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Graph', [],...
                          @(data) isa(data,'digraph')||issparse(data)||isvector(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
            if(~isa(obj.Graph,'digraph'))
                obj.Graph = skeletonGraph(obj.Graph);
            end
        end
        
        function updatePose(obj,Pose,poseType,poseSpace)
            poseType  = capital(poseType);
            poseSpace = capital(poseSpace);
            if(~any(strcmpi(poseType,{'reference','current'})))
                error('poseType must be either ''reference'' or ''current''.');
            end
            if(~any(strcmpi(poseSpace,{'local','model'})))
                error('poseSpace must be either ''local'' or ''model''.');
            end
            obj.(poseType).(poseSpace) = Pose;
            if(strcmpi(poseSpace,'local'))
                obj.(poseType).Model = local2model(pbj.Graph,Pose);
            else
                obj.(poseType).Local = model2local(pbj.Graph,Pose);
            end
        end
        
        function updateReference(obj,Pose,poseSpace)
            updatePose(obj,Pose,'Reference',poseSpace);
        end
        
        function updateCurrent(obj,Pose,poseSpace)
            updatePose(obj,Pose,'Current',poseSpace);
        end
        
        function [Pose] = getRelative(obj)
            Pose = current2relative(obj.Reference.Model,obj.Current.Model);
        end
    end
end