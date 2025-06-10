classdef VertexPickerPlugin < AbstractPickerPlugin
    properties( Access = private )
        PointHandle
    end
    
    methods
        function [obj] = VertexPickerPlugin(varargin)
            obj@AbstractPickerPlugin(varargin{:});
        end
        
        function [obj] = connectProgramData(obj,program)
            h = ViewerData();
            h.addprop('Index');
            obj.Output = program.setData('VertexPickerData',h);
        end
        
        function [obj] = createUserInterface(obj,program)
            menu  = program.getMenu('Selection');
            mitem = uimenu(menu,'Text','Vertex Picker');
            mitem.MenuSelectedFcn = @obj.sendActivationRequest;
        end
        
        function [obj] = activationRoutine(obj,program)
            obj.Input = program.getData('MeshData');
            obj.Input = obj.Input.Handle;
            obj.buildPickerData(obj.Input.Vertices);
        end
        
        function [obj] = deactivationRoutine(obj,program)
            obj.destroyPickerData();
            set(obj.Input,'ButtonDownFcn',[]);
            delete(obj.PointHandle);
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
            [~,i] = selectkNearestPoint(obj,event.IntersectionPoint,1);
            if(ismember(x,obj.Output.Index))
                obj.Output.Index = setdiff(obj.Output.Index,i);
            else
                obj.Output.Index = [obj.Output.Index;i];
            end
            obj.updateGraphics();
        end
        
        function [obj] = EventKeyPress(obj,source,event)
            update = false;
            if(any(strcmpi(event.Modifier,'control')))
                switch event.Key
                    case 'a'
                        if(any(strcmpi(event.Modifier,'shift')))
                            obj.Output.Index = [];
                        else
                            obj.Output.Index = (1:row(obj.Input.Vertices))';
                        end
                        update = true;
                    case 'i'
                        obj.Output.Index = setdiff((1:row(obj.Input.Vertices))',obj.Output.Index);
                        update = true;
                end
            end
            switch event.Key
                case 'x'
                    notify(obj,'RequestDeactivation');
            end
            if(update)
                obj.updateGraphics();
            end
        end
        
        function [obj] = updateGraphics(obj)
            delete(obj.PointHandle);
            obj.PointHandle = point3(obj.Input.Vertices(obj.Output.Index,:),20,'r','filled');
        end
        
    end
end