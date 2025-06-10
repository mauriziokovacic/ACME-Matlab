classdef ImplicitOperator < AbstractImplicitSurface
    methods(Access = public, Sealed = true)
        function [self] = ImplicitOperator(varargin)
            self@AbstractImplicitSurface();
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Primitive', [], @(data) isa(data,'ImplicitSurface'));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                self.(name{i}) = parser.Results.(name{i});
            end
        end
    end
    
    methods(Access = public)
        function [y, dx] = f(self, x)
            y  = zeros(row(x), numel(self.Primitive));
            dx = zeros(row(x), col(x), numel(self.Primitive));
            for i = 1 : numel(self.Primitive)
                [y(:,i), dx(:,:,i)] = self.Primitive(i).f(x);
            end
            [y, dx] = self.eval(y, dx);
        end
    end
    
    methods(Access = protected, Abstract)
        [y, dx] = eval(self, y, dx)
    end
end