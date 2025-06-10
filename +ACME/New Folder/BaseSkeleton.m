classdef BaseSkeleton < handle
    properties( Access = public, SetObservable )
        Graph
        JointList
        BoneList
        Name(1,:) char = '';
    end
    
    events
        PoseChanged
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = BaseSkeleton(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Graph',     [], @(data) isa(data,'digraph'));
            addParameter( parser, 'JointList', [], @(data) isa(data,'BaseJoint'));
            addParameter( parser, 'BoneList',  [], @(data) isa(data,'BaseBone'));
            addParameter( parser, 'Name',      '', @(data) isstring(data)||ischar(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function [j] = getJointByName(obj,name)
            j = [];
            k = findnode(obj.Graph,name);
            if(isempty(k))
                return;
            end
            j = obj.JointList(k);
        end
        
        function [b] = getBoneByName(obj,name)
            b = [];
            j = getJointByName(obj,name);
            if(isempty(j))
                return;
            end
            b = j.AttachedBone;
        end
        
        function [n] = nJoint(obj)
            n = numel(obj.JointList);
        end
        
        function [n] = nBone(obj)
            n = numel(obj.BoneList);
        end
        
        function [n] = nExtremity(obj)
            n = sum(isextremity(obj.JointList));
        end
        
        function [Pose] = referenceLocalPose(obj)
            Pose = arrayfun(@(j) [referenceFrame(j);0 0 0 1], obj.JointList, 'UniformOutput', false);
        end
        
        function [Pose] = referenceModelPose(obj)
            Pose = local2model(obj.Graph,referenceLocalPose(obj));
        end
        
        function [Pose] = currentLocalPose(obj)
            Pose = arrayfun(@(j) [currentFrame(j);0 0 0 1], obj.JointList, 'UniformOutput', false);
        end
        
        function [Pose] = currentModelPose(obj)
            Pose = local2model(obj.Graph,currentLocalPose(obj));
        end
        
        function [Pose] = relativePose(obj)
            Pose = current2relative(referenceModelPose(obj),currentModelPose(obj));
        end
        
        function [varargout] = referenceData(obj)
            n = numnodes(obj.Graph);
            T = zeros(n,3);
            R = zeros(n,3);
            for i = 1 : n
                T(i,:) = referenceData(obj.JointList(i));
                if(isextremity(obj.JointList(i)))
                    continue;
                end
                R(i,:) = referenceData(obj.JointList(i).AttachedBone);
            end
            if(nargout<=1)
                varargout{1} = [T R];
            end
            if(nargout==2)
                varargout{1} = T;
                varargout{2} = R;
            end
        end
        
        function [varargout] = currentData(obj)
            n = numnodes(obj.Graph);
            T = zeros(n,3);
            R = zeros(n,3);
            for i = 1 : n
                T(i,:) = currentData(obj.JointList(i));
                if(isextremity(obj.JointList(i)))
                    continue;
                end
                R(i,:) = currentData(obj.JointList(i).AttachedBone);
            end
            if(nargout<=1)
                varargout{1} = [T R];
            end
            if(nargout==2)
                varargout{1} = T;
                varargout{2} = R;
            end
        end
        
        function [varargout] = currentDelta(obj)
            n = numnodes(obj.Graph);
            T = zeros(n,3);
            R = zeros(n,3);
            for i = 1 : n
                T(i,:) = obj.JointList(i).Delta;
                if(isextremity(obj.JointList(i)))
                    continue;
                end
                R(i,:) = obj.JointList(i).AttachedBone.Delta;
            end
            if(nargout<=1)
                varargout{1} = [T R];
            end
            if(nargout==2)
                varargout{1} = T;
                varargout{2} = R;
            end
        end
        
        function discardDelta(obj)
%             for i = 1 : numel(obj.JointList)
%                 resetDelta(obj.JointList(i));
%             end
%             for i = 1 : numel(obj.BoneList)
%                 resetDelta(obj.BoneList(i));
%             end
            assignPosefromDelta(obj,zeros(numnodes(obj.Graph),6));
        end
        
        function updateBoneLength(obj)
            Pose = referenceModelPose(obj);
            n = numnodes(obj.Graph);
            s = [];
            e = [];
            for i = 1 : n
                s = [s;Pose{i}(1:3,4)'];
            end
            for i = 1 : n
                j = successors(obj.Graph,i);
                if(isempty(j))
                    e = [e;s(i,:)];
                else
                    e = [e;mean(s(j,:),1)];
                end
            end
            l = vecnorm3(e-s);
            for i = 1 : n
                if(isempty(obj.JointList(i).AttachedBone))
                    continue;
                end
                obj.JointList(i).AttachedBone.Length = l(i);
            end
        end
        
        function [h] = show(obj,varargin)
            Pose = currentModelPose(obj);
            h = [];
            for i = 1 : numel(Pose)
%                 h = [h;SpherePatch(Pose{i}(1:3,4)',0.2,4,...
%                                    'EdgeColor','k',...
%                                    'FaceLighting','flat',...
%                                    'UserData',i)];
                if(isextremity(obj.JointList(i)))
                    continue;
                end
                l = obj.JointList(i).AttachedBone.Length;
                h = [h;bonePatch(l,Pose{i},'UserData',i)];
            end
            if(~isempty(varargin))
                set(h,varargin{:});
            end
        end
        
        function [P,N,T,k] = skel2mesh(obj)
            Pose = currentModelPose(obj);
            P = [];
            N = [];
            T = [];
            k = [];
            offset = 0;
            for i = 1 : numel(Pose)
%                 [p,n,t] = Sphere(Pose{i}(1:3,4)',0.2,4);
%                 P = [P;p];
%                 N = [N;n];
%                 T = [T;quad2tri(t)+offset];
%                 k = [k;repmat(i,row(p),1)];
%                 offset = row(P);
                if(isextremity(obj.JointList(i)))
                    continue;
                end
                l = obj.JointList(i).AttachedBone.Length;
                [p,n,t] = boneOctahedron(l,Pose{i});
                P = [P;p];
                N = [N;-n];
                T = [T;polyflip(t)+offset];
                k = [k;repmat(i,row(p),1)];
                offset = row(P);
            end
        end
        
        function [h] = showLineBone(obj,varargin)
            Pose = currentModelPose(obj);
            h = [];
            for i = 1 : numel(Pose)
                if(isextremity(obj.JointList(i)))
                    continue;
                end
                l = obj.JointList(i).AttachedBone.Length;
                h = [h;boneLine(l,Pose{i},'UserData',i)];
            end
            if(~isempty(varargin))
                set(h,varargin{:});
            end
        end
        
        function assignReferenceLocalPose(obj,Pose)
            for i = 1 : numnodes(obj.Graph)
                setReferenceFrame(obj.JointList(i),Pose{i});
            end
            updateBoneLength(obj);
            notify(obj,'PoseChanged');
        end
        
        function assignReferenceModelPose(obj,Pose,reorient)
            if(nargin<3)
                reorient = false;
            end
            if(numel(Pose)~=numnodes(obj.Graph))
                error('Pose size must be equal to the skeleton joints size.');
            end
            if(reorient)
                Pose = BaseSkeleton.reorientPose(obj.Graph,Pose);
            end
            refpose = Pose;
            for i = 1 : numnodes(obj.Graph)
                p = predecessors(obj.Graph,i);
                if(isempty(p))
                    continue;
                end
                refpose{i} = Pose{p}\Pose{i};
            end
            assignReferenceLocalPose(obj,refpose);
        end
        
        function assignReferenceFromRelativePose(obj,Pose)
            Pose = relative2current(referenceModelPose,Pose);
            assignReferenceModelPose(obj,Pose);
        end
        
        function assignCurrentLocalPose(obj,Pose)
            for i = 1 : numnodes(obj.Graph)
                setCurrentFrame(obj.JointList(i),Pose{i});
            end
            notify(obj,'PoseChanged');
        end
        
        function assignCurrentModelPose(obj,Pose)
            Pose = model2local(obj.Graph,Pose);
            assignCurrentLocalPose(obj,Pose);
        end
        
        function assignCurrentFromRelativePose(obj,Pose)
            Pose = relative2current(referenceModelPose(obj),Pose);
            assignCurrentModelPose(obj,Pose)
        end
        
        function assignPosefromDelta(obj,Delta)
            for i = 1 : numnodes(obj.Graph)
                obj.JointList(i).Delta = Delta(i,1:3);
                if(~isextremity(obj.JointList(i)))
                    obj.JointList(i).AttachedBone.Delta = Delta(i,4:6);
                end
            end
            notify(obj,'PoseChanged');
        end
        
        function assignPoseFromAnimation(obj,Anim,frameTime)
            [T,R] = Anim.fetchFrame(frameTime);
            assignPosefromDelta(obj,[T,R]);
        end
        
        function assignRandomPose(obj,fixed)
            if(nargin<2)
                fixed = [];
            end
            n     = numnodes(obj.Graph);
            [~,R] = currentDelta(obj);
            Delta = [zeros(n,3) clamp(randn(n,3),-1,1)*pi];
            for i = 1 : numel(fixed)
                Delta(fixed(i),:) = [zeros(1,3) R(fixed(i),:)];
            end
            assignPosefromDelta(obj,Delta);
        end
        
        function [S,I] = boneSegment(obj)
            Q = referenceJointPosition(obj);
            S = struct('A',[],'B',[]);
            I = [];
            for i = 1 : numnodes(obj.Graph)
                c = successors(obj.Graph,i);
                if(isempty(c))
                    c = i;
                end
                S.A = [S.A;repmat(Q(i,:),numel(c),1)];
                S.B = [S.B;Q(c,:)];
                I   = [I;repmat(i,numel(c),1)];
                
%                 for j = 1 : numel(c)
%                     S.A = [S.A;Q(i,:)];
%                     S.B = [S.B;Q(c(j),:)];
%                     I   = [I;i];
%                 end
            end
        end
        
        function [Q,I] = project_on_bone(obj,P)
            [S,I] = boneSegment(obj);
            J = unique(I);
            Q = cell(row(P),1);
            for i = 1 : row(P)
                Q{i} = zeros(numel(J),3);
                for j = 1 : numel(J)
                    k = find(J(j)==I);
                    x = project_point_on_segment(S.A(k,:),S.B(k,:),P(i,:));
                    Q{i}(j,:) = x(min_index(distance(P(i,:),x)),:);
                end
            end
            I = J;
%             Q = arrayfun(@(i) project_point_on_segment(S.A,S.B,P(i,:)),(1:row(P))','UniformOutput',false);
        end
        
        function [I,D] = closestBone(obj,P)
            [S,ID] = boneSegment(obj);
            D = arrayfun(@(i) point_segment_distance(S.A,S.B,P(i,:)),(1:row(P))','UniformOutput',false);
            I = cellfun(@(d) ID(min_index(d)),D);
            D = cellfun(@(d) min(d),D);
        end
        
        function [P] = referenceJointPosition(obj)
            P = cell2mat(cellfun(@(m) m(1:3,4)',referenceModelPose(obj),'UniformOutput',false));
        end
        
        function [P] = currentJointPosition(obj)
            P = cell2mat(cellfun(@(m) m(1:3,4)',currentModelPose(obj),'UniformOutput',false));
        end
        
        function [N] = referenceJointOrientation(obj)
            P = referenceJointPosition(obj);
            N = zeros(size(P));
            for i = 1 : nJoint(obj)
                c = successors(obj.Graph,i);
                if(isempty(c))
                    continue;
                end
                N(i,:) = mean(P(c,:),1)-P(i,:);
            end
            for i = 1 : nJoint(obj)
                c = successors(obj.Graph,i);
                if(isempty(c))
                    c = predecessors(obj.Graph, i);
                    if(~isempty(c))
                        N(i,:) = N(c,:);
                    end
                end
            end
        end
        
        function [N] = currentJointOrientation(obj)
            P = currentJointPosition(obj);
            N = zeros(numel(obj.JointList),3);
            for i = 1 : numel(obj.JointList)
                p = predecessors(obj.Graph,i);
                c = successors(obj.Graph,i);
                if(~isempty(p))
                    x = P(p,:);
                else
                    x = P(i,:);
                end
                if(~isempty(c))
                    N(i,:) = sum(P(c,:)-x,1);
                else
                    N(i,:) = sum(P(i,:)-x,1);
                end
            end
            N = normr(N);
        end
    
        function [tf] = isRoot(obj,i)
            if(nargin<2)
                i = (1 : nJoint(obj))';
            end
            tf = arrayfun(@(j) isempty(predecessors(obj.Graph,j)),i);
        end
        
        function [tf] = isLeaf(obj,i)
            if(nargin<2)
                i = (1 : nJoint(obj))';
            end
            tf = arrayfun(@(j) isempty(successors(obj.Graph,j)),i);
        end
        
        function [tf] = isJoint(obj,i)
            if(nargin<2)
                i = (1 : nJoint(obj))';
            end
            tf = arrayfun(@(j) (numel(predecessors(obj.Graph,j))==1) && ...
                               (numel(  successors(obj.Graph,j))==1),i);
        end
        
        function [tf] = isBranch(obj,i)
            if(nargin<2)
                i = (1 : nJoint(obj))';
            end
            tf = arrayfun(@(j) numel(successors(obj.Graph,j))>1,i);
        end
    end
    
    methods( Access = public, Static )
        function [Pose] = reorientPose(S,Pose)
            n = numnodes(S);
            s = [];
            e = [];
            for i = 1 : n
                s = [s;Pose{i}(1:3,4)'];
            end
            for i = 1 : n
                j = successors(S,i);
                if(isempty(j))
                    e = [e;s(i,:)];
                else
                    e = [e;mean(s(j,:),1)];
                end
            end
            for i = 1 : n
                E       = e(i,:)-s(i,:);
                d       = norm(E);
                if(d>0.0001)
                    E       = E/d;
                    ax      = normr(cross(E,[0 0 1],2));
                    ang     = vecangle(E,[0 0 1]);
                    R       = axang2rotm([ax ang])';
                else
                    R = eye(3);
                end
                Pose{i} = [R,s(i,:)';0 0 0 1];
            end
        end

        function [obj] = createFromSkeletonPose(S,Pose)
            if(~iscell(Pose))
                Pose = lin2mat(Pose);
            end
            if(isa(S,'BaseSkeleton'))
                S = S.Graph;
            end
            obj = BaseSkeleton();
            obj.Graph = S;
            n = numnodes(S);
            j = [];
            b = [];
            for i = 1 : n
                j = [j;BaseJoint()];
                s = successors(S,i);
                if(isempty(s))
                    continue;
                end
                b = [b;BaseBone()];
                j(end).AttachedBone  = b(end);
                b(end).AttachedJoint = j(end);
            end
            obj.JointList = j;
            obj.BoneList  = b;
            assignReferenceModelPose(obj,Pose,true);
%             assignReferenceLocalPose(obj,Pose);
        end
    end
end