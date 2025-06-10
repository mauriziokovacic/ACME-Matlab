classdef AbstractDeformer < handle
    properties( Access = public, SetObservable )
        Mesh
        Skin
%         Handle
        RecomputeNormal
        Name
        GhostEnabled
    end
    
    events
        DataDeformed
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = AbstractDeformer(varargin)
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Mesh',               [], @(data) isa(data,'AbstractMesh'));
            addParameter( parser, 'Skin',               [], @(data) isa(data,'AbstractSkin'));
%             addParameter( parser, 'Handle',      [], @(data) isa(data,'AbstractHandle'));
            addParameter( parser, 'RecomputeNormal', false, @(data) islogical(data));
            addParameter( parser, 'Name',               '', @(data) isstring(data)||ischar(data));
            addParameter( parser, 'GhostEnabled',    false, @(data) islogical(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function [h] = show_frame(obj,frame, varargin)
            [P,N] = deform(obj,frame);
            if(obj.RecomputeNormal)
                N = normr(obj.Mesh.adjacency('vf')*triangle_normal(P, obj.Mesh.Face));
            end
            h = display_mesh(P,N,obj.Mesh.Face,varargin{:});
        end
        
        function [fig] = show(obj,Animation,varargin)
            ghost = [];
            xxx = obj;
            function perform(obj,fig,h,Frame)
                persistent x y z;
                Frame = round(Frame);
                tic;
                [P,N] = deform(obj,Animation{Frame});
                notify(xxx, 'DataDeformed');
                if(obj.RecomputeNormal)
                    N = normr(obj.Mesh.adjacency('vf')*triangle_normal(P, obj.Mesh.Face));
                end
                fig.Name        = strcat(obj.getName(),' : ',...
                                         num2str(time2fps(toc)),' FPS');
%                 Skel = evalin('base','Skel');
%                 Skel.assignCurrentFromRelativePose(Animation{Frame});
%                 W_ = evalin('base','W_');
%                 d = normr(W_*Skel.currentJointOrientation());
%                 d = normr(transform_normal(compute_transform(Animation{Frame}, W_),d, 'mat'));
%                 c = evalin('base','c');
%                 c = transform_point(compute_transform(Animation{Frame}, obj.Skin.Weight), c, 'mat');
%                 c = normr(P-c);
                h.Vertices      = P;
                h.VertexNormals = N;
                %h.FaceColor = 'interp';
                %h.FaceVertexCData = d;
                %caxis([0 1]);
%                 
                delete(x);
                delete(y);
% %                 delete(z);
% %                 v = 1200;
                %hold on;
%                 h.FaceColor = [0.2 0.2 0.2];
%                 h.FaceAlpha = 0.2;
%                 x = quiv3(P,PC, 'Color','r');
%                 y = quiv3(P,PC_,'Color','g');
% %                 z = point3(pj(v,:),20,'filled','b');
                
                if(~isempty(ghost))
                    ghost.update();
                end
            end
            
            for i = 1 : numel(obj)
                def      = obj(i);
%                 fig      = CreateViewer3D('headlight');
                fig      = CreateViewer();
                CreateAxes3D();
                addMouseInteraction();
                addBackground();
                fig.Name = def.getName();
                h        = display_mesh(def.Mesh.Vertex,...
                                        def.Mesh.Normal,...
                                        def.Mesh.Face,[],'face');
%                 LightStage();
                addLight();
                cubeFrustum();
                if(~isempty(varargin))
                    set(h,varargin{:});
                end
                if(obj.GhostEnabled)
                    ghost = Ghosting(h.Parent,h);
                end
                frame = uicontrol( fig,...
                    'Style', 'slider',...
                    'Position', [100, 10, 200, 20],...
                    'Min', 1,...
                    'Max', numel(Animation),...
                    'SliderStep', [0.01 0.1],...
                    'Value', 1);

                addlistener( frame, 'ContinuousValueChange',...
                             @(o,e) perform(def,fig,h,o.Value) );
            end
        end
    end
    
    methods( Access = public )
        function [name] = getName(obj)
            name = obj.Name;
        end
    end
    
    methods( Abstract )
        [P,N,varargout] = deform(obj,Pose)
    end
end