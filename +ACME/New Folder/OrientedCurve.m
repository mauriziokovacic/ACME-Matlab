classdef OrientedCurve < BaseCurve
    properties( Access = private, Hidden = true )
        Normal_ {mustBeNumeric, mustBeFinite}
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = OrientedCurve(varargin)
            obj@BaseCurve(varargin{:})
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Normal', [], @(data) isnumeric(data));
            parse(parser,varargin{:});
            obj.Normal_ = parser.Results.Normal;
            addprop(obj,'Weight');
            obj.Weight = parser.Unmatched.Weight;
        end
    end
    
    methods( Access = protected )
        function [N] = get_normal(obj)
            if(isempty(obj.Normal_))
                N = get_normal@BaseCurve(obj);
            else
                N = obj.Normal_;
            end
        end
        
        function set_normal(obj,N)
            for i = 1 : numel(obj)
                obj.Normal_ = N;
            end
        end
    end
end