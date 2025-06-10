classdef ContactViewerPlugin < AbstractPickerPlugin
    properties( Access = private )
        I
        U
        P_
        N_
        PointHandle
        PlaneHandle
        S
    end
    
    methods
        function [obj] = ContactViewerPlugin(varargin)
            obj@AbstractPickerPlugin(varargin{:});
            obj.Bypass = true;
        end
        
        function [obj] = connectProgramData(obj,program)
        end
        
        function [obj] = createUserInterface(obj,program)
            menu  = program.getMenu('Painters');
            mitem = uimenu(menu,'Text','Contact Viewer');
            mitem.MenuSelectedFcn = @obj.sendActivationRequest;
        end
        
        function [obj] = activationRoutine(obj,program)
            obj.Input = program.getData('MeshData');
            obj.Input = obj.Input.Handle;
            obj.buildPickerData(obj.Input.Vertices);
            set(obj.Input,'ButtonDownFcn',@obj.EventMouseLeftClick);
            obj.U  = program.getData('WeightPainterData').Value;
            obj.P_ = program.getData('PositionPainterData').Value;
            obj.N_ = program.getData('NormalPainterData').Value;
            obj.S  = 0.1 .* mesh_scale(obj.Input.Vertices);
        end
        
        function [obj] = deactivationRoutine(obj,program)
            obj.destroyPickerData();
            set(obj.Input,'ButtonDownFcn',[]);
            delete(obj.PointHandle);
            delete(obj.PlaneHandle);
            obj.PointHandle = [];
            obj.PlaneHandle = [];
            obj.U  = [];
            obj.P_ = [];
            obj.N_ = [];
        end
        
        function [obj] = standbyRoutine(obj,varargin)
            if(obj.isStandby())
                set(obj.Input,'ButtonDownFcn',[]);
            else
                set(obj.Input,'ButtonDownFcn',@obj.EventMouseLeftClick);
            end
        end
        
        function [obj] = EventMouseLeftClick(obj,source,event)
            if(source~=obj.Input)
                return;
            end
            [~,obj.I] = selectkNearestPoint(obj,event.IntersectionPoint,1);
            %
            obj.updateGraphics();
        end
        
        
        function [obj] = updateGraphics(obj)
            delete(obj.PointHandle);
            delete(obj.PlaneHandle);
            obj.PointHandle = point3(obj.P_(obj.I,:),20,'r','filled','HandleVisibility','off','HitTest','off','PickableParts','none','Parent',obj.Parent.AxesHandle);
            obj.PlaneHandle = plane3(obj.P_(obj.I,:),obj.N_(obj.I,:),obj.S,[1 1 0 0.2],'HandleVisibility','off','HitTest','off','PickableParts','none','Parent',obj.Parent.AxesHandle);
        end
        
    end
end