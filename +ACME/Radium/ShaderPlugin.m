classdef ShaderPlugin < AbstractPlugin
    properties( Access = private )
        CData
    end
    
    methods
        function [obj] = ShaderPlugin(varargin)
            obj@AbstractPlugin(varargin{:});
            obj.CData = [];
        end
        
        function [obj] = connectProgramData(obj,program)
            obj.Input = program.getData('MeshData');
        end
        
        function [obj] = createUserInterface(obj,program)
            menu  = program.getMenu('Render');
            
            ment  = uimenu(menu,'Text','Entity');
            mitem = uimenu(ment,'Text','Point');
            mitem.MenuSelectedFcn = @obj.selectPoint;
            mitem = uimenu(ment,'Text','Wireframe');
            mitem.MenuSelectedFcn = @obj.selectWireframe;
            mitem = uimenu(ment,'Text','Wired');
            mitem.MenuSelectedFcn = @obj.selectWired;
            mitem = uimenu(ment,'Text','Face');
            mitem.MenuSelectedFcn = @obj.selectFace;
            
            mshad = uimenu(menu,'Text','Shading');
            mitem = uimenu(mshad,'Text','Off');
            mitem.MenuSelectedFcn = @obj.selectOff;
            mitem = uimenu(mshad,'Text','Flat');
            mitem.MenuSelectedFcn = @obj.selectFlat;
            mitem = uimenu(mshad,'Text','Smooth');
            mitem.MenuSelectedFcn = @obj.selectSmooth;
            
            malp  = uimenu(menu,'Text','Alpha');
            mitem = uimenu(malp,'Text','Opaque');
            mitem.MenuSelectedFcn = @obj.selectOpaque;
            mitem = uimenu(malp,'Text','Transparent');
            mitem.MenuSelectedFcn = @obj.selectTransparent;
            
            mfnc = uimenu(menu,'Text','Fancy');
            mitem = uimenu(mfnc,'Text','Cartoon');
            mitem.MenuSelectedFcn = @obj.selectCartoon;
            
            mchr  = uimenu(mfnc,'Text','Chromium');
            mitem = uimenu(mchr,'Text','Red');
            mitem.MenuSelectedFcn = @obj.selectRed;
            mitem = uimenu(mchr,'Text','Green');
            mitem.MenuSelectedFcn = @obj.selectGreen;
            mitem = uimenu(mchr,'Text','Blue');
            mitem.MenuSelectedFcn = @obj.selectBlue;
            
            mitem = uimenu(mfnc,'Text','Curvature');
            mitem.MenuSelectedFcn = @obj.selectCurvature;
            
            mitem = uimenu(mfnc,'Text','Wax');
            mitem.MenuSelectedFcn = @obj.selectWax;
            
            mitem = uimenu(mfnc,'Text','Two-Sided');
            mitem.MenuSelectedFcn = @obj.selectTwoSided;
        end
    end
    
    methods( Access = private, Hidden = true )
        function [obj] = selectPoint(obj,varargin)
            h = obj.Input.Handle;
            if(~isempty(h)&&isvalid(h))
                DisplayPoints(h,[0.5 0.5 0.5]);
                colorbar(h.Parent,'off');
            end
        end
        
        function [obj] = selectWireframe(obj,varargin)
            h = obj.Input.Handle;
            if(~isempty(h)&&isvalid(h))
                DisplayWireframe(h,[0 0 0]);
                colorbar(h.Parent,'off');
            end
        end
        function [obj] = selectWired(obj,varargin)
            h = obj.Input.Handle;
            if(~isempty(h)&&isvalid(h))
                DisplayFace(h,[1 1 1]);
                DisplayWired(h,[0.5 0.5 0.5]);
                colorbar(h.Parent,'off');
            end
        end
        function [obj] = selectFace(obj,varargin)
            delete(obj.CData);
            obj.CData = [];
            h = obj.Input.Handle;
            if(~isempty(h)&&isvalid(h))
                DisplayFace(h,[1 1 1]);
                colorbar(h.Parent,'off');
            end
        end
        
        function [obj] = selectOff(obj,varargin)
            delete(obj.CData);
            obj.CData = [];
            h = obj.Input.Handle;
            if(~isempty(h)&&isvalid(h))
                DisplayNoShading(h);
                colorbar(h.Parent,'off');
            end
        end
        function [obj] = selectFlat(obj,varargin)
            h = obj.Input.Handle;
            if(~isempty(h)&&isvalid(h))
                DisplayFlatShading(h);
                colorbar(h.Parent,'off');
            end
        end
        function [obj] = selectSmooth(obj,varargin)
            h = obj.Input.Handle;
            if(~isempty(h)&&isvalid(h))
                DisplaySmoothShading(h);
                colorbar(h.Parent,'off');
            end
        end
        
        function [obj] = selectOpaque(obj,varargin)
            h = obj.Input.Handle;
            if(~isempty(h)&&isvalid(h))
                DisplayOpaque(h);
                colorbar(h.Parent,'off');
            end
        end
        function [obj] = selectTransparent(obj,varargin)
            h = obj.Input.Handle;
            if(~isempty(h)&&isvalid(h))
                DisplayTransparent(h,0.5);
                colorbar(h.Parent,'off');
            end
        end
        
        function [obj] = selectCartoon(obj,varargin)
            delete(obj.CData);
            obj.CData = CartoonColor(obj.Input.Handle,'blue');
            h = obj.Input.Handle;
            colorbar(h.Parent,'off');
        end
        
        function [obj] = selectCurvature(obj,varargin)
            delete(obj.CData);
            obj.CData = [];
            h = obj.Input.Handle;
            if(~isempty(h)&&isvalid(h))
                P = obj.Input.Vertex;
                T = obj.Input.Face;
                DisplayColor(h,curvature_effect(P,T));
                colorbar(h.Parent,'off');
            end
        end
        
        function [obj] = selectRed(obj,varargin)
            delete(obj.CData);
            obj.CData = ChromeColor(obj.Input.Handle,'Red');
            h = obj.Input.Handle;
            colorbar(h.Parent,'off');
        end
        function [obj] = selectGreen(obj,varargin)
            delete(obj.CData);
            obj.CData = ChromeColor(obj.Input.Handle,'Green');
            h = obj.Input.Handle;
            colorbar(h.Parent,'off');
        end
        function [obj] = selectBlue(obj,varargin)
            delete(obj.CData);
            obj.CData = ChromeColor(obj.Input.Handle,'Blue');
            h = obj.Input.Handle;
            colorbar(h.Parent,'off');
        end
        
        function [obj] = selectWax(obj,varargin)
            delete(obj.CData);
            obj.CData = WaxColor(obj.Input.Handle);
            h = obj.Input.Handle;
            colorbar(h.Parent,'off');
        end
        
        function [obj] = selectTwoSided(obj,varargin)
            delete(obj.CData);
            obj.CData = TwoSidedColor(obj.Input.Handle);
            h = obj.Input.Handle;
            colorbar(h.Parent,'off');
        end
    end
end