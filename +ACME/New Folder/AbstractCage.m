classdef AbstractCage < AbstractMesh
    methods( Access = public, Sealed = true )
        function [obj] = AbstractCage(varargin)
            obj@AbstractMesh(varargin{:});
        end
    end
    
    methods( Access = public )
        function [h] = show(obj,varargin)
            h = display_cage(obj.Vertex,...
                             obj.Face,...
                             varargin{:});
        end
    end
end