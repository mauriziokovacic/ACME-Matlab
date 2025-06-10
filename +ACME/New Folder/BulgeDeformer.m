classdef BulgeDeformer < AbstractDeformer
    properties( Access = public )
        CoR
        CoR_
        Weight_
    end
    
    methods( Access = public )
        function [obj] = BulgeDeformer(varargin)
            obj@AbstractDeformer('Name','COR',varargin{:});
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'CoR',  [], @(data) isnumeric(data));
            addParameter( parser, 'CoR_', [], @(data) isnumeric(data));
            addParameter( parser, 'Weight_',   [], @(data) isnumeric(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function [P,N,varargout] = deform(obj,Pose)
            P  = obj.Mesh.Vertex;
            N  = obj.Mesh.Normal;
            W  = obj.Skin.Weight;
            C  = obj.CoR;
            C_ = obj.CoR_;
            W_ = obj.Weight_;
            
            % Compute transforms
            T  = compute_transform(Pose,W);
            T_ = compute_transform(Pose,W_);
            Q  = compute_quaternion(Pose,W);
            Q_ = compute_quaternion(Pose,W_);
            
            % Translation vector
            PC  = P-C;
            PC_ = P-C_;
            PC  = transform_normal(Q,PC,'dq');
            PC_ = transform_normal(Q_,PC_,'dq');
            
            % Deform cors
            C  = transform_point(T,C,'mat');
            C_ = transform_point(T_,C_,'mat');
            
            % Skin mesh
            P  = C  + PC;
            P_ = C_ + PC_;
            d = clamp(distance(P,P_),0,1);
            P = C + (1-d) .* PC + (d) .* PC_;
            N  = normr(transform_normal(Q,N,'dq'));
            
            if(nargout>=3)
                varargout{1}=normr(PC);
                varargout{2}=normr(PC_);
                varargout{3}=d;
            end
        end
        
        function show_CoR(obj)
            CreateViewer3D('right');
            hold on;
            obj.Mesh.show([1 1 1 0.2]);
            point3(obj.CoR,20,'filled','r');
        end
    end
end