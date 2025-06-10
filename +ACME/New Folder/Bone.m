classdef Bone < handle
    properties( Access = public, SetObservable )
        Parent
        Frame
        Length
        RDelta
        TDelta
        Constraint
        Name
    end

    methods
        function [obj] = Bone(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Parent',                   [], @(data) isa(data,'Bone'));
            addParameter( parser, 'Frame',                eye(4), @(data) all(size(data)==[4 4]));
            addParameter( parser, 'Length',                    1, @(data) isscalar(data));
            addParameter( parser, 'RDelta',           zeros(1,3), @(data) isvector(data));
            addParameter( parser, 'TDelta',           zeros(1,3), @(data) isvector(data));
            addParameter( parser, 'Constraint', [-1;1].*Inf(2,3), @(data) all(size(data)==[2 3]));
            addParameter( parser, 'Name',                     '', @(data) isstring(data)||ischar(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function [P] = startPoint(obj)
            P = zeros(numel(obj),3);
            for i = 1 : numel(obj)
                M      = frame(obj(i));
                P(i,:) = M(1:end-1,end)';
            end
        end
        
        function [P] = endPoint(obj)
            P = startPoint(obj) +  majorAxis(obj) .* arrayfun(@(o) o.Length, obj);
        end
        
        function [M] = delta2matrix(obj)
            M = eul2rotm(clamp(obj.RDelta,obj.Constraint(1,:),obj.Constraint(2,:)));
        end
        
        function [F] = frame(obj)
            F = localFrame(obj);
            if(~isempty(obj.Parent))
                F = frame(obj.Parent) * F;
            end
        end
        
        function [F] = localFrame(obj)
            F = [eul2rotm(clamp(obj.RDelta,obj.Constraint(1,:),obj.Constraint(2,:)))*...
                 obj.Frame(1:3,1:3), obj.TDelta'+obj.Frame(1:3,end); 0 0 0 1];
        end
        
        function setFrame(obj,M)
            for i = 1 : numel(obj)
                obj(i).Frame(1:3,1:3) = M;
            end
        end
        
        function [U] = majorAxis(obj)
            U = zeros(numel(obj),3);
            for i = 1 : numel(obj)
                M      = frame(obj(i));
                U(i,:) = M(1:end-1,end-1)';
            end
        end
        
        function [U] = minorAxis(obj)
            U = zeros(numel(obj),3);
            for i = 1 : numel(obj)
                M      = frame(obj(i));
                U(i,:) = M(1:end-1,end-2)';
            end
        end
        
        function [U] = otherAxis(obj)
            U = zeros(numel(obj),3);
            for i = 1 : numel(obj)
                M      = frame(obj(i));
                U(i,:) = M(1:end-1,end-3)';
            end
        end
        
        function setStartPoint(obj,P)
            obj.Frame(1:end-1,end) = P';
        end
        
        function setEndPoint(obj,P)
            obj.Length = distance(startPoint(obj),P);
            E = normr(P-startPoint(obj));
            ax  = normr(cross(E,majorAxis(obj),2));
            ang = acos(dotN(majorAxis(obj),E));
            obj.Frame(1:3,1:3) = axang2rotm([ax ang])' * obj.Frame(1:3,1:3);
        end
        
        function applyDelta(obj)
            for i = 1 : numel(obj)
                obj(i).Frame = localFrame(obj(i));
                obj(i).Delta = [0 0 0];
            end
        end
        
        function [P,N,T] = bone2mesh(obj)
            [P,~,T] = boneOctahedron(obj.Length);
            f = @(d) d(1:end-1);
            M = frame(obj);%[eul2rotm(obj.Delta) * obj.Frame(1:3,1:3) , obj.Frame(1:3,4); 0 0 0 1];
            P = cell2mat(cellfun(@(p) f((M * [p 1]')'),num2cell(P,2),'UniformOutput',false));
            N = vertex_normal(P,T);
        end
        
        function [h] = show(obj,type,varargin)
            if(nargin<2)
                type = 'solid';
            end
            switch type
                case 'solid'
                    P = zeros(6*numel(obj),3);
                    N = zeros(6*numel(obj),3);
                    T = zeros(8*numel(obj),3);
                    for i = 1 : numel(obj)
                        b = obj(i);
                        [P(1+(i-1)*6:i*6,:),N(1+(i-1)*6:i*6,:),T(1+(i-1)*8:i*8,:)] = bone2mesh(b);
                        T(1+(i-1)*8:i*8,:) = T(1+(i-1)*8:i*8,:)+(i-1)*6;
                    end
                    h = display_mesh(P,N,T,[0.7 0.7 0.7],'wired');
                    h.FaceLighting = 'flat';
                case 'frame'
                    P = zeros(9*numel(obj),3);
                    T = reshape(1:9*numel(obj),3,3*numel(obj))';
                    C = repmat(repelem([Blue();Green();Red()],3,1),numel(obj),1);
                    for i = 1 : numel(obj)
                        b = obj(i);
                        P(1+(i-1)*9:i*9,:) = startPoint(b) + [0 0 0; majorAxis(b); 0 0 0;...
                                                              0 0 0; minorAxis(b); 0 0 0;...
                                                              0 0 0; otherAxis(b); 0 0 0];
                    end
                    h = patch('Faces',T,'Vertices',P,'FaceVertexCData',C,'EdgeColor','flat');
                case 'line'
                    P = interleave(startPoint(obj),endPoint(obj));
                    T = reshape(1:2*numel(obj),2,numel(obj))';
                    T = [T, T(:,1)];
                    h = patch('Faces',T,'Vertices',P,'EdgeColor','k');
            end
            if(~isempty(varargin))
                set(h,varargin{:});
            end
        end
    end
    
    methods( Static )
        function [b] = fromSkeleton(G,Pose)
            s = [];
            t = [];
            for i = 1 : numel(Pose)
                s = [s;Pose{i}(1:3,4)'];
            end
            for i = 1 : numel(Pose)
                j = successors(G,i);
                if(isempty(j))
                    t = [t;s(i,:)];
                else
                    t = [t;mean(s(j,:),1)];
                end
            end
            b = [];
            M = cell(numel(Pose),1);
            for i = 1 : numel(Pose)
                b = [b;Bone()];
                if(distance(s(i,:),t(i,:))>0)
                    setStartPoint(b(i),s(i,:));
                    setEndPoint(b(i),t(i,:));
                else
                    b(end).Frame(1:3,1:3) = zeros(3);
                    b(end).Length         = 0;
                end
                M{i} = b(end).Frame;
            end
            for i = 1 : numel(Pose)
                j = predecessors(G,i);
                if(~isempty(j))
                    b(i).Parent = b(j);
                    b(i).Frame = M{j}\M{i};
                end
            end
        end
    end
end