classdef DQSDeformer < AbstractDeformer
    methods( Access = public )
        function [obj] = DQSDeformer(varargin)
            obj@AbstractDeformer('Name','DQS',varargin{:});
        end
        
        function [P,N,varargout] = deform(obj,Pose)
            [P,N] = Dual_Quaternion_Skinning(obj.Mesh.Vertex,...
                                             obj.Mesh.Normal,...
                                             obj.Skin.Weight,...
                                             Pose);
        end
    end
end