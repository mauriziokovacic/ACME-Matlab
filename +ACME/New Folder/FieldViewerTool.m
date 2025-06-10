classdef FieldViewerTool < ModelViewerTool
    properties( Access = protected, Hidden = true )
        fieldListener
        ViewMode
        FieldTexture
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = FieldViewerTool(varargin)
            obj@ModelViewerTool(varargin{:});
            setTitle(obj,'Field Viewer Tool');
            obj.ObjectHandle.FaceColor       = 'interp';
            obj.ObjectHandle.FaceVertexCData = zeros(nVertex(obj.Parent.Mesh),1);
            obj.FieldTexture = 'king';
            cmap(obj.FieldTexture,256);
            colorbar(obj.AxesHandle.AxesHandle);
            obj.ViewMode = 'smooth';
            setConsoleText(obj,['\textbf{Selection Mode}: ',obj.ViewMode,'\quad \textit{(press v to change)}']);
            
            menu = uimenu(obj.FigureHandle,'Text','Texture');
            uimenu(menu,'Text','Parula','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'parula'));
            uimenu(menu,'Text','Black','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'black'));
            uimenu(menu,'Text','R','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'r'));
            uimenu(menu,'Text','G','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'g'));
            uimenu(menu,'Text','B','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'b'));
            uimenu(menu,'Text','C','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'c'));
            uimenu(menu,'Text','M','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'m'));
            uimenu(menu,'Text','Y','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'y'));
            uimenu(menu,'Text','Fire','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'fire'));
            uimenu(menu,'Text','Brown','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'brown'));
            uimenu(menu,'Text','Orange','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'orange'));
            uimenu(menu,'Text','Blue','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'blue'));
            uimenu(menu,'Text','Green','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'green'));
            uimenu(menu,'Text','Mint','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'mint'));
            uimenu(menu,'Text','Purple','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'purple'));
            uimenu(menu,'Text','Sign','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'sign'));
            uimenu(menu,'Text','King','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'king'));
            uimenu(menu,'Text','Vision','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'vision'));
            uimenu(menu,'Text','Turbo','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'turbo'));
            uimenu(menu,'Text','Pinot','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'pinot'));
            uimenu(menu,'Text','Sky','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'sky'));
            uimenu(menu,'Text','Aqua','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'aqua'));
            uimenu(menu,'Text','Dusk','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'dusk'));
            uimenu(menu,'Text','Relay','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'relay'));
            uimenu(menu,'Text','Sweet','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'sweet'));
            uimenu(menu,'Text','Phoenix','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'phoenix'));
            uimenu(menu,'Text','Ryb','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'RYB'));
            uimenu(menu,'Text','Scale','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'scale'));
            uimenu(menu,'Text','Paint','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'paint'));
            uimenu(menu,'Text','Pastel','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'pastel'));
            uimenu(menu,'Text','Cinolib','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'cinolib'));
            uimenu(menu,'Text','Matlab','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'matlab'));
            uimenu(menu,'Text','Hotspot','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'hotspot'));
            uimenu(menu,'Text','Rainbow','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'rainbow'));
            uimenu(menu,'Text','Hotmetal','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'hotmetal'));
            uimenu(menu,'Text','Coldspot','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'coldspot'));
            uimenu(menu,'Text','Implicit','MenuSelectedFcn',@(varargin) setFieldTexture(obj,'implicit'));
        end
    end
    
    methods( Access = private, Hidden = true )
        function setFieldTexture(obj,textureData)
            obj.FieldTexture = textureData;
            updateFieldTexture(obj);
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            registerProps@ModelViewerTool(obj);
            addProps(obj,'Field');
            obj.fieldListener = addPropListener(obj,...
                                               'Field',...
                                               @(varargin) showField(obj));
        end
        
        function delete(obj)
            delete(obj.fieldListener);
        end
    end
    
    methods( Access = public )
        function EventKeyPress(obj,~,event)
            switch event.Key
                case 'v'
                    if(strcmpi(obj.ViewMode,'discrete'))
                        obj.ViewMode = 'smooth';
                    else
                        obj.ViewMode = 'discrete';
                    end
                    updateFieldTexture(obj);
            end
            setConsoleText(obj,['\textbf{View Mode}: ',obj.ViewMode,'\quad \textit{(press v to change)}']);
        end
        
        function showField(obj)
            M = getProps(obj,'Mesh');
            F = getProps(obj,'Field');
            if(isempty(F)||(sum(F)==0))
                F = zeros(nVertex(M),1);
            end
            obj.ObjectHandle.FaceVertexCData = F;
            caxis(obj.AxesHandle.AxesHandle,[min(F) max(F)]);
            updateFieldTexture(obj);
        end
        
        function updateFieldTexture(obj)
            if(strcmpi(obj.ViewMode,'discrete'))
                cmap(obj.FieldTexture,10);
            else
                cmap(obj.FieldTexture,256);
            end
        end

    end
end