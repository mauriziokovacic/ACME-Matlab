classdef AbstractHandle < handle
    properties( Access = public, SetObservable )
        Transform
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = AbstractHandle(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Transform', [], @(data) isa(data,'AbstractTransform'));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
    end
end