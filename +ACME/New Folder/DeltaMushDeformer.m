classdef DeltaMushDeformer < AbstractDeformer
    properties( Access = public, SetObservable )
        Delta
        Mush
    end
    
    properties( Access = private )
        Matrix
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = DeltaMushDeformer(varargin)
            obj@AbstractDeformer('Name','DeltaMush',varargin{:});
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Delta', zeros(size(obj.Mesh.Vertex)), @(data) isnumeric(data));
            addParameter( parser, 'Mush',  zeros(size(obj.Mesh.Vertex)), @(data) isnumeric(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function createMush(obj,lambda)
            if(nargin<2)
                lambda = 0.7;
            end
            P = obj.Mesh.Vertex;
            T = obj.Mesh.Face;
            L = cotangent_Laplacian(P,T);
            obj.Mush  = P;
            obj.Matrix = decomposition(speye(row(P))+lambda*L);
            for i = 1 : 10
                obj.Mush  = obj.Matrix\obj.Mush;
            end
            obj.Delta = P-obj.Mush;
        end
    end
    
    methods( Access = public )
        function [P,N] = deform(obj,Pose)
            T = compute_transform(Pose,obj.Skin.Weight);
            Q = compute_quaternion(Pose,obj.Skin.Weight);
            S = transform_point(T,obj.Mesh.Vertex,'mat');
            for i = 1 : 10
                S = obj.Matrix\S;
            end
            D = transform_normal(Q,obj.Delta,'dq');
            N = transform_normal(Q,obj.Mesh.Normal,'dq');
            P = S+D;
        end
    end
    
end