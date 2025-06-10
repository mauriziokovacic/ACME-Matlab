classdef CameraExtrinsic < handle
    properties
        Position
        Target
        UpVector
    end
    
    methods
        function [obj] = CameraExtrinsic(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Position', [0 0 0], @(data) isnumeric(data));
            addParameter( parser, 'Target',   [0 0 1], @(data) isnumeric(data));
            addParameter( parser, 'UpVector', [0 1 0], @(data) isnumeric(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function [self] = from_axes(self, h)
            self.Position = h.CameraPosition;
            self.Target   = h.CameraTarget;
            self.UpVector = h.CameraUpVector;
        end
        
        function to_axes(self, h)
            h.CameraPosition = self.Position;
            h.CameraTarget   = self.Target;
            h.CameraUpVector = self.UpVector;
        end
        
        function [D] = direction(self)
            D = self.Target - self.Position;
        end
        
        function [M] = view_matrix(self)
            z = normr(self.direction());
            x = normr(cross(self.UpVector, z, 2));
            y = cross(z, x, 2);
            p = self.Position;
            M = [x' y' z' p'; 0 0 0 1];
        end
    end
end