classdef AbstractAnimation < handle
    properties( Access = public, SetObservable )
        Translation
        Rotation
        Scaling
        TimeRange
    end
    
    methods( Access = public )
        function [obj] = AbstractAnimation(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter(parser,'Translation',[],@(data) isa(data,'AnimationTrack'));
            addParameter(parser,'Rotation',   [],@(data) isa(data,'AnimationTrack'));
            addParameter(parser,'Scaling',    [],@(data) isa(data,'AnimationTrack'));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
            updateTimeRange(obj);
        end
        
        function updateTimeRange(obj)
            obj.TimeRange = [Inf -Inf];
            for i = 1 : numel(obj.Translation)
                t = timeRange(obj.Translation(i));
                obj.TimeRange = [min(obj.TimeRange(1),t(1)),...
                                 max(obj.TimeRange(2),t(2))];
            end
            for i = 1 : numel(obj.Rotation)
                t = timeRange(obj.Rotation(i));
                obj.TimeRange = [min(obj.TimeRange(1),t(1)),...
                                 max(obj.TimeRange(2),t(2))];
            end
            for i = 1 : numel(obj.Scaling)
                t = timeRange(obj.Scaling(i));
                obj.TimeRange = [min(obj.TimeRange(1),t(1)),...
                                 max(obj.TimeRange(2),t(2))];
            end
        end
        
        function [varargout] = fetchFrame(obj,frameTime)
            if(nargout>=1)
                T = zeros(numel(obj.Translation),3);
                for i = 1 : numel(obj.Translation)
                    T(i,:) = obj.Translation(i).fetchTrack(frameTime);
                end
                varargout{1} = T;
            end
            if(nargout>=2)
                R = zeros(numel(obj.Rotation),3);
                for i = 1 : numel(obj.Rotation)
                    R(i,:) = obj.Rotation(i).fetchTrack(frameTime);
                end
                varargout{2} = R;
            end
            if(nargout>=3)
                S =  ones(numel(obj.Scaling),3);
                for i = 1 : numel(obj.Scaling)
                    S(i,:) = obj.Scaling(i).fetchTrack(frameTime);
                end
                varargout{3} = S;
            end
        end
    end
    
    methods( Static )
        function [obj] = createFromSkeleton(S)
            if(isa(S,'BaseSkeleton'))
                S = S.Graph;
            end
            if(~isa(S,'digraph'))
                error(['Expecting a ''digraph'' or ''BaseSkeleton''. Got a ',class(S),'.']);
            end
            obj = AbstractAnimation();
            n = numnodes(S);
            obj.Translation = arrayfun(@(i) AnimationTrack('DefaultKey',[0 0 0],'Name',S.Nodes.Name{i}),(1:n)');
            obj.Rotation    = arrayfun(@(i) AnimationTrack('DefaultKey',[0 0 0],'Name',S.Nodes.Name{i}),(1:n)');
            obj.Scaling     = arrayfun(@(i) AnimationTrack('DefaultKey',[1 1 1],'Name',S.Nodes.Name{i}),(1:n)');
            updateTimeRange(obj);
        end
        
        function [obj] = createFromAnimation(S,Rest,Frame)
            if(isa(S,'BaseSkeleton'))
                S = S.Graph;
            end
            if(~isa(S,'digraph'))
                error(['Expecting a ''digraph'' or ''BaseSkeleton''. Got a ',class(S),'.']);
            end
            obj     = AbstractAnimation.createFromSkeleton(S);
            S0      = BaseSkeleton.createFromSkeletonPose(S,Rest);
            RefPose = referenceModelPose(S0);
            for f = 1 : numel(Frame)
                F = lin2mat(Frame{f});
                if(numel(F)<numel(RefPose))
                    n = numel(RefPose)-numel(F);
                    F = [F;arrayfun(@(i) eye(4),(1:n)','UniformOutput',false)];
                end
                assignCurrentFromRelativePose(S0,F);
                [T,R] = currentDelta(S0);
                for i = 1 : numnodes(S)
                    obj.Translation(i).insertKey(f,T(i,:));
                    obj.Rotation(i).insertKey(f,R(i,:));
                end
            end
            updateTimeRange(obj);
        end
    end
end