classdef GizmoRotate < AbstractGizmo
    properties( Access = private, SetObservable )
        XHit(1,1) logical = false
        YHit(1,1) logical = false
        ZHit(1,1) logical = false
    end
    
    methods( Access = public )
        function show(obj,fig)
            if(nargin<2)
                fig = handle(gcf);
            end
            ax = get_axes(fig);
            ax = [ax;CreateAxes3D(fig)];
            connect_axes(ax);
            uistack(ax,'top');
            
            f = obj.Target.currentFrame();
            u = f(:,1)';
            v = f(:,2)';
            w = f(:,3)';
            o = f(:,4)';
            h = line3([o o+u],'LineWidth',2,...
                      'Color','r',...
                      'HitTest',true,'PickableParts','all');
            h = line3([o o+v],'LineWidth',2,...
                      'Color','g',...
                      'HitTest',true,'PickableParts','all');
            h = line3([o o+w],'LineWidth',2,...
                      'Color','b',...
                      'HitTest',true,'PickableParts','all');

%             set(h,'HitTest',true,'PickableParts','all');
%             set(h,'ButtonDownFcn',@(varargin) click(obj,'X'));
%             
%             addMouseInteraction('Figure',fig,...
%                 'EventScroll',           '@(varargin) nop()',...
%                 'EventLeftGrab',         '@(varargin) nop()',...
%                 'EventLeftGrabRelease',  '@(varargin) nop()',...
%                 'EventRightGrab',        @(o,e) obj.move(h,e),...
%                 'EventRightGrabRelease', @(varargin) obj.unclick());
        end
    end
    
    methods
        function apply(obj,delta)
            
        end
        
        function click(obj, ax)
            obj.([upper(ax),'Hit']) = true;
        end
        
        function unclick(obj)
            obj.XHit = false;
            obj.YHit = false;
            obj.ZHit = false;
        end
        
        function move(obj,h,e)
            persistent last;
            if(nargin==0)
                last = [];
                return;
            end
            if(isempty(last))
                last = e.Position;
            end
            p    = e.Position;
            dp   = p-last;
            last = p;
            if(obj.XHit)
                h.Vertices = h.Vertices + [dp(1) dp(2) 0];
            end
            if(obj.YHit)
                h.Vertices = h.Vertices + [dp(1) dp(2) 0];
            end
            if(obj.ZHit)
                h.Vertices = h.Vertices + [dp(1) dp(2) 0];
            end
        end
    end
end