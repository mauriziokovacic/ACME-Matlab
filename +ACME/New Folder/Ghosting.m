classdef Ghosting < handle
    properties( Access = public, SetObservable )
        Enabled
        Ghost
        Frame
    end
    
    properties( Access = private, Hidden = true )
        Count
        Axes
        Handle
    end
    
    methods( Access = public )
        function [obj] = Ghosting(ax,h,varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addRequired( parser,       'ax',       @(data) isaxes(data));
            addRequired( parser,        'h',       @(data) ispatch(data));
            addParameter( parser, 'Enabled', true, @(data) islogical(data));
            addParameter( parser,   'Ghost',    4, @(data) isscalar(data));
            addParameter( parser,   'Frame',    5, @(data) isscalar(data));
            parse(parser,ax,h,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                if(strcmpi(name{i},'ax')||strcmpi(name{i},'h'))
                    continue;
                end
                obj.(name{i}) = parser.Results.(name{i});
            end
            obj.Count  = 1;
            obj.Axes   = arrayfun(@(~) copy_axes_properties(ax,CreateAxes3D(ax.Parent)),1:obj.Ghost-1);
            obj.Handle = arrayfun(@(~) copy_patch_properties(h,patch()),1:obj.Ghost-1);
            obj.Axes   = [obj.Axes,ax];
            obj.Handle = [obj.Handle,h];
            updateStacking(obj);
            updateParent(obj);
            addlistener(obj,'Enabled','PostSet',@(varargin) obj.updateVisibility());
        end
        
        function update(obj)
            updateAxes(obj);
            if(obj.Enabled)
                obj.Count = obj.Count+1;
                if( obj.Count == obj.Frame )
                    updateFrame(obj);
                    obj.Count = 1;
                end
            end
        end
    end
    
    methods( Access = private, Hidden = true )
        function updateFrame(obj)
            obj.Handle(1:end-1)             = circshift(obj.Handle(1:end-1),-1);
            set(obj.Handle(1:end-1),'FaceColor',0.3*(Cyan()+Blue()+ones(1,3)));
            obj.Handle(end-1).Vertices      = obj.Handle(end).Vertices;
            obj.Handle(end-1).VertexNormals = obj.Handle(end).VertexNormals;
            updateParent(obj);
            updateAlpha(obj);
        end
        
        function updateAxes(obj)
            arrayfun(@(a) copy_axes_properties(obj.Axes(end),a),obj.Axes(1:end));
        end
        
        function updateAlpha(obj)
            alpha = linspace(0.2,1,numel(obj.Handle)).^2;
            arrayfun(@(i) set(obj.Handle(i),'FaceAlpha',alpha(i)),1:numel(obj.Handle));
        end
        
        function updateParent(obj)
            arrayfun(@(h,a) set(h,'Parent',a),obj.Handle,obj.Axes);
        end
        
        function updateStacking(obj)
            arrayfun(@(a) uistack(a,'top'),obj.Axes(1:end));
        end
        
        function updateVisibility(obj)
            arrayfun(@(a) set(a,'Visible',obj.Enabled),obj.Axes(1:end-1));
            arrayfun(@(h) set(h,'Visible',obj.Enabled),obj.Handle(1:end-1));
        end
    end
end