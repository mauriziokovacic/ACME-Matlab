classdef PaintPlugin < Plugin
    properties
        Perform = false;
    end
    methods
        function [obj] = MouseEventClick(obj,source,event)
            obj.Perform = true;
        end
        
        function [obj] = MouseEventRelease(obj,source,event)
            obj.Perform = false;
        end
        
        function [obj] = MouseEventMove(obj,source,event)
            if( obj.Perform )
                ax = obj.Parent.getAxes();
                O  = ax.CurrentPoint(1,:);
                D  = (ax.CurrentPoint(1,:) - ax.CurrentPoint(2,:));
                h = get_patch(ax);
                T = evalin('base','T');
                P = evalin('base','P');
                [I,J,K] = tri2ind(T);
                x = ray_triangle_intersection(O,D,P(I,:),P(J,:),P(K,:));
                [i,~] = find(isfinite(x));
                i = unique(i);
                if( ~isempty(i) )
                    k = repmat([1 1 1],row(T),1);
                    k(i,:) = repmat([1 0 0],numel(i),1);
                    h.FaceVertexCData = k;
                    h.FaceColor       = 'flat';
                end
            end
        end
    end
end