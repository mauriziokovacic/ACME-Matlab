classdef LBSDeformer < AbstractDeformer
    methods( Access = public )
        function [obj] = LBSDeformer(varargin)
            obj@AbstractDeformer('Name','LBS',varargin{:});
        end
        
        function [P,N,varargout] = deform(obj,Pose)
            [P,N] = Linear_Blend_Skinning(obj.Mesh.Vertex,...
                                          obj.Mesh.Normal,...
                                          obj.Skin.Weight,...
                                          Pose);
        end
    end
end