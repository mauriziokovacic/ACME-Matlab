classdef CameraIntrinsic < handle
    properties
        FOV
        Near
        Far
        ImageSize
    end
    
    methods
        function [obj] = CameraIntrinsic(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'FOV',       [], @(data) isscalar(data));
            addParameter( parser, 'Near',      [], @(data) isscalar(data));
            addParameter( parser, 'Far',       [], @(data) isscalar(data));
            addParameter( parser, 'ImageSize', [], @(data) isnumeric(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function [self] = from_axes(self, h)
            self.FOV = h.CameraViewAngle;
            self.Near = 0.0001;
            self.Far = 100000;
            self.ImageSize = h.Position(3:4);
        end
        
        function to_axes(self, h)
            h.CameraViewAngle = self.FOV;
            
        end
        
        function [a] = aspect(self)
            a = self.ImageSize(1) / self.ImageSize(2);
        end
        
        function [M] = projection_matrix(self)
            fov = deg2rad(self.FOV);
            M = zeros(4);
            M(1, 1) = 1 / (self.aspect() * tan(fov / 2));
            M(2, 2) = 1 / tan(fov / 2);
            M(3, 3) = (self.Far + self.Near) / (self.Far - self.Near);
            M(3, 4) = -2 * (self.Far * self.Near) / (self.Far - self.Near);
            M(4, 3) = 1;
        end
    end
end