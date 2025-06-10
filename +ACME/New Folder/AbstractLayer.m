classdef AbstractLayer < InteractiveObject
    properties( Access = public, SetObservable )
        Parent
        
        Visible
        Lock

        Axes
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = AbstractLayer(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addRequired(  parser, 'Parent',         @(data) isfigure(data));
            addParameter( parser, 'Visible',  true, @(data) islogical(data));
            addParameter( parser, 'Lock',    false, @(data) islogical(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
            obj.Axes = CreateAxes3D(obj.Parent);
        end
        
        function toggleVisible(obj,tf)
            obj.Axes.Visible = tf;
            set(obj.Axes.Children,'Visible',tf);
        end
        
        function setVisible(obj)
            toggleVisible(obj,true);
        end
        
        function setInvisible(obj)
            toggleVisible(obj,false);
        end
        
        function toggleLock(obj,tf)
            if(tf)
                pp = 'none';
            else
                pp = 'visible';
            end
            set(obj.Axes,'PickableParts',pp,'HitTest',tf);
            set(obj.Axes.Children,'PickableParts',pp,'HitTest',tf);
        end
        
        function setLocked(obj)
            toggleLock(obj,true);
        end
        
        function setUnlocked(obj)
            toggleLock(obj,false);
        end
    end
end