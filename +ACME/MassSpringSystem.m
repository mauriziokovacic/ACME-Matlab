classdef MassSpringSystem < handle
    properties
        % Mass
        Weight
        Position
        Velocity
        Acceleration
        Fixed
        
        % Spring
        Length
        Stiffness
        
        % Conn
        Edge
        
        Name
    end
    
    methods
        function [obj] = MassSpringSystem(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Weight',          [], @(data) isnumeric(data));
            addParameter( parser, 'Position',        [], @(data) isnumeric(data));
            addParameter( parser, 'Velocity',        [], @(data) isnumeric(data));
            addParameter( parser, 'Acceleration',    [], @(data) isnumeric(data));
            addParameter( parser, 'Fixed',        false, @(data) islogical(data));
            addParameter( parser, 'Length',          [], @(data) isnumeric(data));
            addParameter( parser, 'Stiffness',       [], @(data) isnumeric(data));
            addParameter( parser, 'Edge',            [], @(data) isnumeric(data));
            addParameter( parser, 'Name',            '', @(data) isstring(data)||ischar(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function simulate(obj,dt)
            F                = obj.spring_force();
            D                = -1 .* obj.Velocity;
            F = F+D;
            obj.Acceleration = obj.Acceleration + ~obj.Fixed .* (F ./ obj.Weight);
            obj.Velocity     = obj.Velocity     + ~obj.Fixed .* (obj.Acceleration .* dt);
            obj.Position     = obj.Position     + obj.Velocity .* dt;
        end
        
        function [h] = show(obj,h)
            if(nargin<2)
                h = display_curve(obj.Position,obj.Edge);
            end
            h.Vertices = obj.Position;
        end
    end
    
    methods
        function [F] = spring_force(obj)
            [i,j]  = edge2ind(obj.Edge);
            l0 = obj.Length;
            ks = obj.Stiffness;
            P  = obj.Position;
            d  = P(j,:)-P(i,:);
            l  = vecnorm(d,2,2);
            F  = zeros(size(P));
            f  = ks .* ( d ./ l ) .* ( l - l0 );
            F([i;j],:) = [f;-f];
        end
    end
end