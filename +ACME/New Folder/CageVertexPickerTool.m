classdef CageVertexPickerTool < PickerTool
    properties( Access = private, Hidden = true )
        PointHandle
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = CageVertexPickerTool(varargin)
            obj@PickerTool(varargin{:});
            setTitle(obj,'Cage Vertex Selection Tool');
            DisplayWired(obj.ObjectHandle);
            set(obj.ObjectHandle,'ButtonDownFcn',@(o,e) selectVertex(obj,e.IntersectionPoint));
            hold on;
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            addProps(obj,'Cage');
            addProps(obj,'HandleIndex');
        end
    end
    
    methods( Access = public )
        function selectVertex(obj,P)
            delete(obj.PointHandle);
            obj.PointHandle = [];
            M = getProps(obj,'Cage');
            V = getProps(obj,'HandleIndex');
            i = M.knn(P);
            V = selectObject(obj,V,i);
            setProps(obj,'HandleIndex',V);
            if(~isempty(V))
                obj.PointHandle = point3(M.Vertex(V,:),20,'filled','r');
            end
        end
        
        function [h] = showObject(obj)
            C = obj.Parent.Cage;
            C.recompute_normals();
            h = display_mesh(C.Vertex,C.Normal,polyflip(C.Face),[1 1 1],'wired',[],'FaceLighting','flat');
        end
    end
    
    methods( Static )
        function [obj] = standAlone(varargin)
            parser = inputParser;
            addRequired( parser, 'Cage', @(data) isa(data,'AbstractCage'));
            parse(parser,varargin{:});
            h   = SharedDataSystem('Cage',parser.Results.Cage);
            obj = VertexPickerTool(h);
        end
    end
end