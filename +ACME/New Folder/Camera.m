classdef Camera < handle 
    properties
        Intrinsic
        Extrinsic
    end
    
    methods
        function [obj] = Camera(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Intrinsic', [], @(data) isscalar(data));
            addParameter( parser, 'Extrinsic', [], @(data) isscalar(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function [self] = from_axes(self, h)
            self.Intrinsic = CameraIntrinsic().from_axes(h);
            self.Extrinsic = CameraExtrinsic().from_axes(h);
        end
        
        function to_axes(self, h)
            self.Intrinsic.to_axes(h);
            self.Extrinsic.to_axes(h);
        end
        
        function [varargout] = project(self, P, pixels)
            if(nargin<3)
                pixels = false;
            end
            s = 0.5;
            if pixels
                % Image width and height
                w = self.Intrinsic.ImageSize(1) - 1;
                h = self.Intrinsic.ImageSize(2) - 1;
                % Normalization factor (bring the coordinates from [-1,1] to [0, w], [0, h] and [0, 1] respectively)
                s = s * [w, h, 1];
            end
            % Transform the points into homogeneous coordinates, transform them into camera space and then project them
            view = self.Extrinsic.view_matrix();
            UVd  = homo2cart(cart2homo(P)*view');
            proj = self.Intrinsic.projection_matrix();
            
            UVd = cart2homo(UVd) * proj';
            % Bring the points into normalized homogeneous coordinates and normalize their values
            UVd = homo2cart(UVd) .* s + s;
            if nargout==1
                varargout{1} = UVd;
                return;
            end
            if nargout==2
                varargout{1} = UVd(:,1:2);
                varargout{2} = UVd(:,3);
                return;
            end
            if nargout>=3
                varargout{1} = UVd(:,1);
                varargout{2} = UVd(:,2);
                varargout{3} = UVd(:,3);
                return;
            end
        end

        function [P] = unproject(self, UVd, pixels)
            if(nargin<3)
                pixels = false;
            end
            s = 2;
            if pixels
                % Image width and height
                w = self.Intrinsic.ImageSize(1) - 1;
                h = self.Intrinsic.ImageSize(2) - 1;
                % Normalization factor (brings the coordinates to [-1, 1])
                s = s ./ [w, h, 1];
            end
            % Change the points domain, transform them into homogeneous, and invert the projection process
            MVP = self.Intrinsic.projection_matrix()*self.Extrinsic.view_matrix();
            P = cart2homo(UVd .* s - 1) * inv(MVP)';
            % Normalize the coordinates
            P = homo2cart(P);
        end
    end
end