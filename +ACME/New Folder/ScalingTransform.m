classdef ScalingTransform < AbstractTransform
    methods( Access = public, Sealed = true )
        function [obj] = ScalingTransform(varargin)
            obj@AbstractTransform(varargin{:});
        end
    end
    
    methods( Access = protected, Static )
        function [X] = convertData(data)
            X = diag(data);
        end
    end
end