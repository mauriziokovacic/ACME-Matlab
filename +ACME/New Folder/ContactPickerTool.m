classdef ContactPickerTool < PickerTool
    properties( Access = protected, Hidden = true )
        PointHandle
        vertexListener
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = ContactPickerTool(varargin)
            obj@PickerTool(varargin{:});
            setTitle(obj,'Contact Selection Tool');
            DisplayWired(obj.ObjectHandle);
            set(obj.ObjectHandle,'ButtonDownFcn',@(o,e) selectContact(obj,e.IntersectionPoint));
            obj.Parent.Contact = obj.Parent.Mesh.Vertex;
            hold on;
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            addProps(obj,'Mesh');
            addProps(obj,'VertexIndex');
            addProps(obj,'Contact');
            obj.vertexListener = addPropListener(obj,'VertexIndex',@(varargin) selectVertex(obj));
        end
    end
    
    methods( Access = public )
        function selectVertex(obj)
            V = getProps(obj,'VertexIndex');
            C = getProps(obj,'Contact');
            delete(obj.PointHandle);
            obj.PointHandle = [];
            if(~isempty(V))
                obj.PointHandle = point3(C(V,:),20,'filled','b','Parent',obj.AxesHandle.AxesHandle);
            end
        end
        
        function selectContact(obj,P)
            delete(obj.PointHandle);
            obj.PointHandle = [];
            V = getProps(obj,'VertexIndex');
            C = getProps(obj,'Contact');
            if(~isempty(V))
                C(V,:) = P;
                setProps(obj,'Contact',C);
                obj.PointHandle = point3(P,20,'filled','b','Parent',obj.AxesHandle.AxesHandle);
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