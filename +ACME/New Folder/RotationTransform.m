classdef RotationTransform < AbstractTransform
    methods( Access = public, Sealed = true )
        function [obj] = RotationTransform(varargin)
            obj@AbstractTransform(varargin{:});
        end
    end
    
    methods( Access = protected, Static )
        function [X] = convertData(data)
            X = eul2rotm(data);
        end
    end
end