classdef BaseBone < Editable
    properties( Access = public, SetObservable )
        AttachedJoint
        Length
    end
    
    methods
        function [obj] = BaseBone(varargin)
            obj@Editable(varargin{:});
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Length', 0, @(data) isscalar(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function [M] = referenceFrame(obj)
            M = [eul2rotm(referenceData(obj)),zeros(3,1)];
        end
        
        function [M] = currentFrame(obj)
            M = [eul2rotm(currentData(obj)),zeros(3,1)];
        end
        
        function setReferenceFrame(obj,frame)
            obj.Data = rotm2eul(frame(1:3,1:3));
        end
        
        function setCurrentFrame(obj,frame)
            obj.Delta = rotm2eul(frame(1:3,1:3)) - obj.Data;
        end
        
        function [h] = show(obj,varargin)
            h = bonePatch(obj.Length,[currentFrame(obj); 0 0 0 1],varargin{:});
            h.Vertices = h.Vertices + currentData(obj.AttachedJoint);
        end
    end
end
