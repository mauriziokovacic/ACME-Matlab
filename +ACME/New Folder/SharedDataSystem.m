classdef SharedDataSystem < dynamicprops
    properties( Access = private, Hidden = true )
        PropsMap
        Children
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = SharedDataSystem(varargin)
            obj.PropsMap = containers.Map;
            if(mod(nargin,2)==1)
                error('Wrong input. Missing argument value or argument name.');
            end
            for i = 1 : 2 : numel(varargin)
                emplaceProps(obj,varargin{i},varargin{i+1});
            end
        end
    end
    
    methods( Access = public, Sealed = true )
        function registerChild(obj,child)
            obj.Children = [obj.Children;{child}];
        end
        
        function flushChildren(obj)
            for i = 1 : numel(obj.Children)
                c = obj.Children{i};
                if(isprop(c,'FigureHandle'))
                    if(isvalid(c.FigureHandle))
                        close(c.FigureHandle);
                    end
                end
                delete(c);
            end
        end
        
        function [tf] = isProps(obj,propName)
            tf = ~isempty(findprop(obj,propName));
        end
        
        function addProps(obj,propName)
            if(~isProps(obj,propName))
                prop = obj.addprop(propName);
                prop.SetObservable = true;
                obj.PropsMap(propName) = prop;
            end
        end
        
        function [value] = getProps(obj,propName)
            if(~isProps(obj,propName))
                error(['Property ', propName, ' not found.']);
            end
            value = obj.(propName);
        end
        
        function setProps(obj,propName,propValue)
            if(~isProps(obj,propName))
                error(['Property ', propName, ' not found.']);
            end
            obj.(propName) = propValue;
        end
        
        function emplaceProps(obj,propName,propValue)
            addProps(obj,propName);
            setProps(obj,propName,propValue);
        end
        
        function [h] = addPropListener(obj,propName,valueChangeFcn)
            if(isempty(valueChangeFcn))
                error('valueChangeFcn cannot be empty.');
            end
            if(~isProps(obj,propName))
                error(['Property ', propName, ' not found.']);
            end
            h = addlistener(obj,propName,'PostSet',valueChangeFcn);
            
        end
        
        function removeProps(obj,propName)
            if(isempty(findprop(obj,propName)))
                warning(['Property ', propName, ' not found.']);
                return;
            end
            delete(obj.PropsMap(propName));
            remove(obj.PropsMap,propName);
        end
        
        function importProps(obj,propName,varName,workSpace)
            if(nargin<4)
                workSpace = 'base';
            end
            addProps(obj,propName);
            setProps(obj,propName,evalin(workSpace,varName));
        end
        
        function exportProps(obj,propName,varName,workSpace)
            if(nargin<4)
                workSpace = 'base';
            end
            value = getProps(obj,propName);
            assignin(workSpace,varName,value);
        end
        
        function flushProps(obj)
            name = keys(obj.PropsMap);
            for i = 1 : numel(name)
                removeProps(obj,name{i});
            end
        end
        
        function reset(obj)
            flushChildren(obj);
            flushProps(obj);
        end
    end
    
    methods( Access = public, Static )
        function [obj] = ModelViewerSystem(Mesh)
            obj = SharedDataSystem('Mesh',Mesh);
            ModelViewerTool(obj);
        end
        
        function [obj] = VertexSelectionSystem(Mesh)
            obj = SharedDataSystem('Mesh',Mesh);
            VertexPickerTool(obj);
        end
        
        function [obj] = DeformerSystem(Mesh,Skin,Skel,Anim)
            if(numnodes(Skel.Graph)>col(Skin.Weight))
                Skin.Weight = [Skin.Weight sparse(row(Skin.Weight),abs(numnodes(Skel.Graph)-col(Skin.Weight)))];
            end
            obj = SharedDataSystem('Mesh',Mesh,...
                                   'Skin',Skin,...
                                   'Skel',Skel,...
                                   'Anim',Anim);
            PlayerControlTool(obj);
            SkeletonAnimationTool(obj);
            SkeletonViewerTool(obj);
            SkeletonDeformerViewerTool.LBSTool(obj);
        end
        
        function [obj,varargout] = DeformerComparisonSystem(Mesh,Skin,Skel,Anim,varargin)
            if(numnodes(Skel.Graph)>col(Skin.Weight))
                Skin.Weight = [Skin.Weight sparse(row(Skin.Weight),abs(numnodes(Skel.Graph)-col(Skin.Weight)))];
            end
            obj = SharedDataSystem('Mesh',Mesh,...
                                   'Skin',Skin,...
                                   'Skel',Skel,...
                                   'Anim',Anim);
            h = {PlayerControlTool(obj)};
            h = [h;{SkeletonAnimationTool(obj)}];
%             SkeletonViewerTool(obj);
%             SkeletonDeformerViewerTool.LBSTool(obj);
%             SkeletonDeformerViewerTool.DQSTool(obj);
            for i = 1 : numel(varargin)
                h = [h;{SkeletonDeformerViewerTool(obj)}];
                h{end}.Deformer = varargin{i};
                h{end}.Deformer.Skin = Skin;
                setTitle(h{end},h{end}.Deformer.Name);
            end
            if(nargout>=2)
                varargout{1} = h;
            end
        end
        
        function [obj] = CurveSketcherSystem(Mesh)
            obj = SharedDataSystem('Mesh',Mesh);
            CurveSketcherTool(obj);
        end
        
        function [obj] = FoldSketcherSystem(Mesh,Skin,Skel)
            if(numnodes(Skel.Graph)>col(Skin.Weight))
                Skin.Weight = [Skin.Weight sparse(row(Skin.Weight),abs(numnodes(Skel.Graph)-col(Skin.Weight)))];
            end
            obj = SharedDataSystem.CurveSketcherSystem(Mesh);
            emplaceProps(obj,'Skin',Skin);
            emplaceProps(obj,'Skel',Skel);
            SkeletonPickerTool(obj);
            FoldStrokeTool(obj);
        end
        
        function [obj] = SkeletonWeightViewerSystem(Mesh,Skin,Skel)
            if(numnodes(Skel.Graph)>col(Skin.Weight))
                Skin.Weight = [Skin.Weight sparse(row(Skin.Weight),abs(numnodes(Skel.Graph)-col(Skin.Weight)))];
            end
            obj = SharedDataSystem('Mesh',Mesh,...
                                   'Skin',Skin,...
                                   'Skel',Skel);
            SkeletonPickerTool(obj);
            HandleWeightTool(obj);
            FieldViewerTool(obj);
        end
        
        function [obj] = SkeletonInfluenceViewerSystem(Mesh,Skin,Skel)
            if(numnodes(Skel.Graph)>col(Skin.Weight))
                Skin.Weight = [Skin.Weight sparse(row(Skin.Weight),abs(numnodes(Skel.Graph)-col(Skin.Weight)))];
            end
            obj = SharedDataSystem('Mesh',Mesh,...
                                   'Skin',Skin,...
                                   'Skel',Skel);
            VertexPickerTool(obj);
            SkeletonInfluencerViewerTool(obj);
        end
        
        function [obj] = HarmonicFieldViewerSystem(Mesh)
            obj = SharedDataSystem('Mesh',Mesh);
            VertexPickerTool(obj);
            HarmonicFieldTool(obj);
            FieldViewerTool(obj);
        end
        
        function [obj] = HeatDiffusionViewerSystem(Mesh,type)
            if(nargin<2)
                type='single';
            end
            obj = SharedDataSystem('Mesh',Mesh);
            PlayerControlTool(obj);
            if(strcmpi(type,'single'))
                VertexPickerTool(obj);
            else
                CurveSketcherTool(obj);
                CurveSelectionTool(obj);
            end
            HeatDiffusionTool(obj);
            FieldViewerTool(obj);
        end
        
        function [obj] = GeodesicDistanceViewerSystem(Mesh,type)
            if(nargin<2)
                type='single';
            end
            obj = SharedDataSystem('Mesh',Mesh);
            if(strcmpi(type,'single'))
                VertexPickerTool(obj);
            else
                CurveSketcherTool(obj);
                CurveSelectionTool(obj);
            end
            GeodesicDistanceTool(obj);
            FieldViewerTool(obj);
        end
        
        function [obj] = EuclideanDistanceViewerSystem(Mesh)
            obj = SharedDataSystem('Mesh',Mesh);
            PointPickerTool(obj);
            EuclideanDistanceTool(obj);
            FieldViewerTool(obj);
        end
    end
end