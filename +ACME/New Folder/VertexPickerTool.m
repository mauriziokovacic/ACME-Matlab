classdef VertexPickerTool < PickerTool
    properties( Access = protected, Hidden = true )
        PointHandle
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = VertexPickerTool(varargin)
            obj@PickerTool(varargin{:});
            setTitle(obj,'Vertex Selection Tool');
            DisplayWired(obj.ObjectHandle);
            set(obj.ObjectHandle,'ButtonDownFcn',@(o,e) selectVertex(obj,e.IntersectionPoint));
            hold on;
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            addProps(obj,'Mesh');
            addProps(obj,'VertexIndex');
            addProps(obj,'VertexSelection');
        end
    end
    
    methods( Access = public )
        function selectVertex(obj,P)
            delete(obj.PointHandle);
            obj.PointHandle = [];
            M = getProps(obj,'Mesh');
            V = getProps(obj,'VertexIndex');
            S = getProps(obj,'VertexSelection');
            i = M.knn(P);
            [V,S] = selectObject(obj,V,i,S);
            setProps(obj,'VertexSelection',S);
            setProps(obj,'VertexIndex',V);
            if(~isempty(V))
                obj.PointHandle = [obj.PointHandle;point3(M.Vertex(V(~S),:),20,'filled','r','Parent',obj.AxesHandle.AxesHandle)];
                obj.PointHandle = [obj.PointHandle;point3(M.Vertex(V( S),:),20,'filled','b','Parent',obj.AxesHandle.AxesHandle)];
            end
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
            obj = VertexPickerTool(h);
        end
    end
end