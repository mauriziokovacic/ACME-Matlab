classdef FoldViewerTool < HandleWeightViewerTool
    methods( Access = public, Sealed = true )
        function [obj] = FoldViewerTool(varargin)
            obj@HandleWeightViewerTool(varargin{:});
            setTitle(obj,'Fold Viewer Tool');
            obj.WeightTexture = 'implicit';
            cmap(obj.WeightTexture,256);
        end
    end
    
    methods( Static )
        function [obj] = standAlone(varargin)
            parser = inputParser;
            addRequired( parser, 'Mesh', @(data) isa(data,'AbstractMesh'));
            addRequired( parser, 'Skin', @(data) isa(data,'AbstractSkin'));
            parse(parser,varargin{:});
            h   = SharedDataSystem('Mesh',parser.Results.Mesh,...
                                   'Skin',parser.Results.Skin);
            obj = FoldViewerTool(h);
        end
    end
end

% classdef FoldViewerTool < ModelViewerTool
%     properties
%         FoldHandle
%     end
%     
%     properties( Access = private, Hidden = true )
%         handleListener
%     end
%     
%     methods( Access = public, Sealed = true )
%         function [obj] = FoldViewerTool(varargin)
%             obj@ModelViewerTool(varargin{:});
%             setTitle(obj,'Fold Viewer Tool');
%         end
%     end
%     
%     methods( Access = public )
%         function registerProps(obj)
%             registerProps@ModelViewerTool(obj);
%             addProps(obj,'Skin');
%             addProps(obj,'HandleIndex');
%             obj.handleListener = addPropListener(obj,...
%                                                'HandleIndex',...
%                                                @(varargin) selectHandle(obj));
%         end
%         
%         function delete(obj)
%             delete(obj.handleListener);
%         end
%     end
%     
%     methods( Access = public )
%         function selectHandle(obj)
%             if(~isvalid(obj))
%                 return;
%             end
%             delete(obj.FoldHandle);
%             obj.FoldHandle = [];
%             M = getProps(obj,'Mesh');
%             S = getProps(obj,'Skin');
%             H = getProps(obj,'HandleIndex');
%             if(~isempty(H))
%                 FC = FoldCurve.createFromWeights(M,sum(S.Weight(:,H),2));
%                 if(~isempty(FC))
%                     obj.FoldHandle = FC.show('Parent',        obj.AxesHandle.AxesHandle,...
%                                              'EdgeColor',     'r',...
%                                              'PickableParts', 'none',...
%                                              'HitTest',       'off');
%                 end
%             end
%         end
%     end
%     
%     methods( Static )
%         function [obj] = standAlone(varargin)
%             parser = inputParser;
%             addRequired( parser, 'Mesh', @(data) isa(data,'AbstractMesh'));
%             addRequired( parser, 'Skin', @(data) isa(data,'AbstractSkin'));
%             parse(parser,varargin{:});
%             h   = SharedDataSystem('Mesh',parser.Results.Mesh,...
%                                    'Skin',parser.Results.Skin);
%             obj = FoldViewerTool(h);
%         end
%     end
% end