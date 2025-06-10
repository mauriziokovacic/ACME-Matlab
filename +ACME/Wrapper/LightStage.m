classdef LightStage < handle
    properties( Access = public, SetObservable )
        Axes
        Point(:,2) {mustBeFinite}
        Color(:,3) {mustBeFinite}
        Visible    logical = true
        Name(1,:)  char = ''
    end
    
    properties( Access = private, Hidden = true )
        LightHandle
        CListener
        PListener
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = LightStage(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Axes', handle(gca), @(data) isaxes(data));
            addParameter( parser, 'Point',      [0 0;-pi/2 0;pi/2 0], @(data) isnumeric(data));
            addParameter( parser, 'Color',    [White();Red();Blue()], @(data) isnumeric(data));
            addParameter( parser, 'Name',          '', @(data) isstring(data)||ischar(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
            addlistener(obj, 'Axes',    'PostSet', @(varargin) cellfun(@(f) feval(f), {obj.unbind, obj.bind}));
            obj.PListener = {addlistener(obj, 'Point',   'PostSet', @(varargin) obj.update),...
                             addlistener(obj, 'Color',   'PostSet', @(varargin) obj.update),...
                             addlistener(obj, 'Visible', 'PostSet', @(varargin) obj.update)};
            obj.bind();
            obj.update();
        end
        
        function insert_light(obj,varargin)
            for l = 1 : numel(obj.PListener)
                obj.PListener{l}.Enabled = false;
            end
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Point',      [0 0], @(data) isnumeric(data));
            addParameter( parser, 'Color',    [1 1 1], @(data) isnumeric(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = [obj.(name{i});parser.Results.(name{i})];
            end
            for l = 1 : numel(obj.PListener)
                obj.PListener{l}.Enabled = true;
            end
            obj.create_light();
        end
        
        function remove_light(obj, i)
            for l = 1 : numel(obj.PListener)
                obj.PListener{l}.Enabled = false;
            end
            obj.Point(i,:) = [];
            obj.Color(i,:) = [];
            for l = 1 : numel(obj.PListener)
                obj.PListener{l}.Enabled = true;
            end
            obj.create_light();
        end
    end
    
    methods( Access = public )
        function delete(obj)
            unbind(obj);
        end
    end
    
    methods( Access = public, Static )
    end
    
    methods( Access = public )
        function bind(obj)
            obj.create_light();
            obj.CListener = cell(5,1);
            obj.CListener{1} = addlistener(obj.Axes,'Projection',      'PostSet', @(varargin) obj.update());
            obj.CListener{2} = addlistener(obj.Axes,'CameraPosition',  'PostSet', @(varargin) obj.update());
            obj.CListener{3} = addlistener(obj.Axes,'CameraTarget',    'PostSet', @(varargin) obj.update());
            obj.CListener{4} = addlistener(obj.Axes,'CameraUpVector',  'PostSet', @(varargin) obj.update());
            obj.CListener{5} = addlistener(obj.Axes,'CameraViewAngle', 'PostSet', @(varargin) obj.update());
        end
        
        function unbind(obj)
            cellfun(@(c) delete(c), obj.CListener);
            if(~isempty(obj.LightHandle))
                cellfun(@(c) delete(c), obj.LightHandle);
            end
            obj.CListener   = [];
            obj.LightHandle = [];
        end
        
        function create_light(obj)
            if(~isempty(obj.LightHandle))
                cellfun(@(c) delete(c), obj.LightHandle);
            end
            obj.LightHandle = cell(row(obj.Point),1);
            for i = 1 : row(obj.Point)
                l = light(obj.Axes, 'Style', 'local');
                obj.LightHandle{i} = l;
            end
            obj.update()
        end
        
        function update(obj)
            c = campos(obj.Axes);
            t = camtarget(obj.Axes);
            u = camup(obj.Axes);
%             a = get(obj.Axes, 'DataAspectRatio');
%             [~,~,r] = cart2sph(c(1),c(2),c(3));
%             for i = 1 : row(obj.Point)
%                 p = camrotate(c,t,a,u,obj.Point(i,1)*r,obj.Point(i,2)*r,'camera',[]);
%                 set(obj.LightHandle{i},'Color',    obj.Color(i,:),...
%                                        'Position', p,...
%                                        'Style',    'local',...
%                                        'Parent',   obj.Axes,...
%                                        'Visible',  obj.Visible);
%             end
            d = normr(t-c);
            r = normr(cross(u,d,2));
            for i = 1 : row(obj.Point)
                p = (RUt(r, obj.Point(i,2), 'matrix') * [c 1]');
                p = (RUt(u, obj.Point(i,1), 'matrix') * p)';
                p = p(1:3);
                set(obj.LightHandle{i},'Color',    obj.Color(i,:),...
                                       'Position', p,...
                                       'Style',    'local',...
                                       'Parent',   obj.Axes,...
                                       'Visible',  obj.Visible);
            end
        end
    end
end