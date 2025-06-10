classdef TranslationTransform < AbstractTransform
    methods( Access = public, Sealed = true )
        function [obj] = TranslationTransform(varargin)
            obj@AbstractTransform(varargin{:});
        end
    end
    
    methods( Access = protected, Static )
        function [X] = convertData(data)
            X = data';
        end
    end
end