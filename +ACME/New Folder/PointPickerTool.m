classdef PointPickerTool < PickerTool
    properties( Access = protected, Hidden = true )
        PointHandle
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = PointPickerTool(varargin)
            obj@PickerTool(varargin{:});
            setTitle(obj,'Point Selection Tool');
%             DisplayWired(obj.ObjectHandle);
            set(obj.ObjectHandle,'ButtonDownFcn',@(o,e) selectPoint(obj,e.IntersectionPoint));
            hold on;
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            addProps(obj,'Mesh');
            addProps(obj,'PointSelection');
        end
    end
    
    methods( Access = public )
        function selectPoint(obj,P)
            delete(obj.PointHandle);
            obj.PointHandle = [];
            S = getProps(obj,'PointSelection');
            if(strcmpi(obj.SelectionMode,'unique'))
                S = P;
            else
                S = [S;P];
            end
            obj.PointHandle = [obj.PointHandle;point3(S,20,'filled','r','Parent',obj.AxesHandle.AxesHandle)];
            setProps(obj,'PointSelection',S);
        end
        
        function [h] = showObject(obj)
            h = obj.Parent.Mesh.show();
        end
    end
    
    methods( Static )
        function [obj] = standAlone(varargin)
            parser = inputParser;
            addRequired( parser, 'Mesh', @(data) isa(data,'AbstractMesh'));
            parse(parser,varargin{:});
            h   = SharedDataSystem('Mesh',parser.Results.Mesh);
            obj = PointPickerTool(h);
        end
    end
end