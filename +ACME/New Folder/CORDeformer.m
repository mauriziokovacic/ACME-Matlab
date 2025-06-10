classdef CORDeformer < AbstractDeformer
    properties( Access = public )
        CoR
    end
    
    methods( Access = public )
        function [obj] = CORDeformer(varargin)
            obj@AbstractDeformer('Name','COR',varargin{:});
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'CoR', [], @(data) isnumeric(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function [P,N,varargout] = deform(obj,Pose)
            [P,N,C] = Center_Of_Rotation(...
                         obj.Mesh.Vertex,...
                         obj.Mesh.Normal,...
                         obj.Skin.Weight,...
                         Pose,...
                         obj.CoR);
            if(nargout>=3)
                varargout{1}=C;
            end
        end
        
        function show_CoR(obj)
            CreateViewer3D('right');
            hold on;
            obj.Mesh.show([1 1 1 0.2]);
            point3(obj.CoR,20,'filled','r');
        end
    end
end