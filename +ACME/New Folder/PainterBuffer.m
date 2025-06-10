classdef PainterBuffer < handle
    properties( Access = public, SetObservable )
        Parent
        Mask
        Position
        Normal
        Depth
    end
    
    methods
        function [obj] = PainterBuffer(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addRequired(  parser, 'Parent',       @(data) isfigure(data));
            addParameter( parser, 'Mask',     [], @(data) isnumeric(data));
            addParameter( parser, 'Position', [], @(data) isnumeric(data));
            addParameter( parser, 'Normal',   [], @(data) isnumeric(data));
            addParameter( parser, 'Depth',    [], @(data) isnumeric(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function [obj] = rebuildBuffers(obj)
            obj.Mask     = ReadBufferMask(obj.Parent);
            obj.Position = ReadBufferPosition(obj.Parent);
            obj.Normal   = ReadBufferNormal(obj.Parent);
%             obj.Depth    = ReadBufferDepth(obj.Parent);
        end
        
        function [i] = computeBufferIndex(obj,currentPoint)
            i   = GetBufferDataIndex(obj.Parent.Position(3:4),...
                                     currentPoint,...
                                     size(obj.Mask));
            if( isempty(i) )
                return;
            end
            i(~obj.Mask(sub2ind(size(obj.Mask),i(:,1),i(:,2))),:) = [];
        end
        
        function [out] = readBuffer(obj,bufferName,bufferIndex)
            out = [];
            if(isempty(bufferIndex))
                return;
            end
            out = fetchBufferData(obj.(bufferName),bufferIndex);
        end
        
        function [P] = readBufferPosition(obj,bufferIndex)
            P = readBuffer(obj,'Position',bufferIndex);
        end
        
        function [N] = readBufferNormal(obj,bufferIndex)
            N = readBuffer(obj,'Normal',bufferIndex);
        end
        
        function [D] = readBufferDepth(obj,bufferIndex)
            D = readBuffer(obj,'Depth',bufferIndex);
        end
    end
end