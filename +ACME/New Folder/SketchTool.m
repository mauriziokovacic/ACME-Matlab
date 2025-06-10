classdef SketchTool < handle
    properties( Access = public, SetObservable )
        Parent
        Point
    end
    
    properties( Access = private, Hidden = true )
        Line
    end
    
    methods
        function [obj] = SketchTool(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addRequired( parser, 'Parent', @(data) isfigure(data));
            addParameter( parser, 'Point', [], @(data) isnumeric(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function delete(obj)
            delete(obj.Line);
            obj.Line = [];
        end
        
        function update(obj)
            if(row(obj.Point)>1)
                P = (obj.Point(end-1:end,:)-1)./(obj.Parent.Position(3:4)-1);
                if(any(P(:)<0)||any(P(:)>1))
                    return;
                end
                obj.Line = [obj.Line;...
                            annotation(obj.Parent,...
                                       'line',...
                                       P(:,1),...
                                       P(:,2),...
                                       'Color','r',...
                                       'Units','pixels')];
            end
        end
        
        function addPoint(obj,P)
            obj.Point = [obj.Point;P];
            update(obj);
        end
        
        function [P] = toPixel(obj)
            P = curve2pixel(obj.Point);
        end
        
        function reset(obj)
            obj.Point = [];
            delete(obj.Line);
            obj.Line = [];
        end
    end
end