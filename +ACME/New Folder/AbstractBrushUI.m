classdef AbstractBrushUI < SharedDataComponent

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        DistanceFcnMenu        matlab.ui.container.Menu
        DistanceEuclideanMenu  matlab.ui.container.Menu
        CutOffFcnMenu          matlab.ui.container.Menu
        CutOffFixedMenu        matlab.ui.container.Menu
        CutOffLinearMenu       matlab.ui.container.Menu
        CutOffQuadraticMenu    matlab.ui.container.Menu
        CutOffCubicMenu        matlab.ui.container.Menu
        CutOffGaussMenu        matlab.ui.container.Menu
        CutOffWyvillMenu       matlab.ui.container.Menu
        PaintFcnMenu           matlab.ui.container.Menu
        PaintAddMenu           matlab.ui.container.Menu
        PaintSubtractMenu      matlab.ui.container.Menu
        PaintMultiplyMenu      matlab.ui.container.Menu
        PaintDivideMenu        matlab.ui.container.Menu
        PaintMixMenu           matlab.ui.container.Menu
        ValidateFcnMenu        matlab.ui.container.Menu
        ValidateIdentityMenu   matlab.ui.container.Menu
        DistanceFcnLabel       matlab.ui.control.UIControl
        CutOffFcnLabel         matlab.ui.control.UIControl
        PaintFcnLabel          matlab.ui.control.UIControl
        ValidateFcnLabel       matlab.ui.control.UIControl
        CutOffFcn              matlab.ui.control.UIControl
        DistanceFcn            matlab.ui.control.UIControl
        PaintFcn               matlab.ui.control.UIControl
        ValidateFcn            matlab.ui.control.UIControl
        ValidateFcnSignature   matlab.ui.control.UIControl
        PaintFcnSignature      matlab.ui.control.UIControl
        CutOffFcnSignature     matlab.ui.control.UIControl
        DistanceFcnSignature   matlab.ui.control.UIControl
        ValueBar               matlab.graphics.illustration.ColorBar
        StrengthBar            matlab.graphics.illustration.ColorBar
        RadiusLabel            matlab.ui.control.UIControl
        Value
        Strength
        Radius                 matlab.ui.control.UIControl
    end

    methods (Access = private)
        % Menu selected function: DistanceEuclideanMenu
        function DistanceEuclideanMenuSelected(app, event)
            app.DistanceFcn.String = 'vecnorm(V,2,2)';
            DistanceFcnValueChanged(app,event);
        end

        % Menu selected function: CutOffFixedMenu
        function CutOffFixedMenuSelected(app, event)
            app.CutOffFcn.String = 'D<0';
            CutOffFcnValueChanged(app,event);
        end

        % Menu selected function: CutOffLinearMenu
        function CutOffLinearMenuSelected(app, event)
            app.CutOffFcn.String = 'D';
            CutOffFcnValueChanged(app,event);
        end

        % Menu selected function: CutOffQuadraticMenu
        function CutOffQuadraticMenuSelected(app, event)
            app.CutOffFcn.String = 'D.^2';
            CutOffFcnValueChanged(app,event);
        end

        % Menu selected function: CutOffCubicMenu
        function CutOffCubicMenuSelected(app, event)
            app.CutOffFcn.String = 'D.^3';
            CutOffFcnValueChanged(app,event);
        end

        % Menu selected function: CutOffGaussMenu
        function CutOffGaussMenuSelected(app, event)
            app.CutOffFcn.String = 'normalize(gaussmf(D,[0.3333 1]),0,1)';
            CutOffFcnValueChanged(app,event);
        end

        % Menu selected function: CutOffWyvillMenu
        function CutOffWyvillMenuSelected(app, event)
            app.CutOffFcn.String = 'wyvill(D)';
            CutOffFcnValueChanged(app,event);
        end

        % Menu selected function: PaintAddMenu
        function PaintAddMenuSelected(app, event)
            app.PaintFcn.String = 'P+B';
            PaintFcnValueChanged(app,event);
        end

        % Menu selected function: PaintSubtractMenu
        function PaintSubtractMenuSelected(app, event)
            app.PaintFcn.String = 'P-B';
            PaintFcnValueChanged(app,event);
        end

        % Menu selected function: PaintMultiplyMenu
        function PaintMultiplyMenuSelected(app, event)
            app.PaintFcn.String = 'P.*B';
            PaintFcnValueChanged(app,event);
        end

        % Menu selected function: PaintDivideMenu
        function PaintDivideMenuSelected(app, event)
            app.PaintFcn.String = 'P./B';
        end

        % Menu selected function: PaintMixMenu
        function PaintMixMenuSelected(app, event)
            app.PaintFcn.String = 'B';
            PaintFcnValueChanged(app,event);
        end

        % Menu selected function: ValidateIdentityMenu
        function ValidateIdentityMenuSelected(app, event)
            app.ValidateFcn.String = 'V';
            ValidateFcnValueChanged(app,event);
        end

        % Value changed function: Value
        function ValueValueChanged(obj, value)
            B       = getProps(obj,'WeightBrush');
            B.Value = value;
            setProps(obj,'WeightBrush',B);
        end
        
        % Value changed function: Strength
        function StrengthValueChanged(obj, value)
            B          = getProps(obj,'WeightBrush');
            B.Strength = value;
            setProps(obj,'WeightBrush',B);
        end
        
        % Value changed function: Radius
        function RadiusValueChanged(obj, value)
            B        = getProps(obj,'WeightBrush');
            B.Radius = value;
            setProps(obj,'WeightBrush',B);
        end
        
        % Value changed function: CutOffFcn
        function CutOffFcnValueChanged(app, event)
            B     = getProps(app,'WeightBrush');
            value = str2func(strcat(app.CutOffFcnSignature.String,' ',app.CutOffFcn.String));
            B.CutOffFcn = value;
            setProps(app,'WeightBrush',B);
        end

        % Value changed function: DistanceFcn
        function DistanceFcnValueChanged(app, event)
            B     = getProps(app,'WeightBrush');
            value = str2func(strcat(app.DistanceFcnSignature.String,' ',app.DistanceFcn.String));
            B.DistanceFcn = value;
            setProps(app,'WeightBrush',B);
        end

        % Value changed function: PaintFcn
        function PaintFcnValueChanged(app, event)
            B     = getProps(app,'WeightBrush');
            value = str2func(strcat(app.PaintFcnSignature.String,' ',app.PaintFcn.String));
            B.PaintFcn = value;
            setProps(app,'WeightBrush',B);
        end

        % Value changed function: ValidateFcn
        function ValidateFcnValueChanged(app, event)
            B     = getProps(app,'WeightBrush');
            value = str2func(strcat(app.ValidateFcnSignature.String,' ',app.ValidateFcn.String));
            B.ValidateFcn = value;
            setProps(app,'WeightBrush',B);
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = figure('Name','Brush Settings','MenuBar','none','ToolBar','none','NumberTitle','off','Resize','off');
            app.UIFigure.Position = [100 100 357 447];
            app.UIFigure.Name = 'Weight Brush Settings';

            % Create DistanceFcnMenu
            app.DistanceFcnMenu = uimenu(app.UIFigure);
            app.DistanceFcnMenu.Text = 'DistanceFcn';

            % Create DistanceEuclideanMenu
            app.DistanceEuclideanMenu = uimenu(app.DistanceFcnMenu);
            app.DistanceEuclideanMenu.MenuSelectedFcn = @(o,e) app.DistanceEuclideanMenuSelected(e);
            app.DistanceEuclideanMenu.Text = 'Euclidean';

            % Create CutOffFcnMenu
            app.CutOffFcnMenu = uimenu(app.UIFigure);
            app.CutOffFcnMenu.Text = 'CutOffFcn';

            % Create CutOffFixedMenu
            app.CutOffFixedMenu = uimenu(app.CutOffFcnMenu);
            app.CutOffFixedMenu.MenuSelectedFcn = @(o,e) app.CutOffFixedMenuSelected(e);
            app.CutOffFixedMenu.Text = 'Fixed';

            % Create CutOffLinearMenu
            app.CutOffLinearMenu = uimenu(app.CutOffFcnMenu);
            app.CutOffLinearMenu.MenuSelectedFcn = @(o,e) app.CutOffLinearMenuSelected(e);
            app.CutOffLinearMenu.Text = 'Linear';

            % Create CutOffQuadraticMenu
            app.CutOffQuadraticMenu = uimenu(app.CutOffFcnMenu);
            app.CutOffQuadraticMenu.MenuSelectedFcn = @(o,e) app.CutOffQuadraticMenuSelected(e);
            app.CutOffQuadraticMenu.Text = 'Quadratic';

            % Create CutOffCubicMenu
            app.CutOffCubicMenu = uimenu(app.CutOffFcnMenu);
            app.CutOffCubicMenu.MenuSelectedFcn = @(o,e) app.CutOffCubicMenuSelected(e);
            app.CutOffCubicMenu.Text = 'Cubic';

            % Create CutOffGaussMenu
            app.CutOffGaussMenu = uimenu(app.CutOffFcnMenu);
            app.CutOffGaussMenu.MenuSelectedFcn = @(o,e) app.CutOffGaussMenuSelected(e);
            app.CutOffGaussMenu.Text = 'Gauss';

            % Create CutOffWyvillMenu
            app.CutOffWyvillMenu = uimenu(app.CutOffFcnMenu);
            app.CutOffWyvillMenu.MenuSelectedFcn = @(o,e) app.CutOffWyvillMenuSelected(e);
            app.CutOffWyvillMenu.Text = 'Wyvill';

            % Create PaintFcnMenu
            app.PaintFcnMenu = uimenu(app.UIFigure);
            app.PaintFcnMenu.Text = 'PaintFcn';

            % Create PaintAddMenu
            app.PaintAddMenu = uimenu(app.PaintFcnMenu);
            app.PaintAddMenu.MenuSelectedFcn = @(o,e) app.PaintAddMenuSelected(e);
            app.PaintAddMenu.Text = 'Add';

            % Create PaintSubtractMenu
            app.PaintSubtractMenu = uimenu(app.PaintFcnMenu);
            app.PaintSubtractMenu.MenuSelectedFcn = @(o,e) app.PaintSubtractMenuSelected(e);
            app.PaintSubtractMenu.Text = 'Subtract';

            % Create PaintMultiplyMenu
            app.PaintMultiplyMenu = uimenu(app.PaintFcnMenu);
            app.PaintMultiplyMenu.MenuSelectedFcn = @(o,e) app.PaintMultiplyMenuSelected(e);
            app.PaintMultiplyMenu.Text = 'Multiply';

            % Create PaintDivideMenu
            app.PaintDivideMenu = uimenu(app.PaintFcnMenu);
            app.PaintDivideMenu.MenuSelectedFcn = @(o,e) app.PaintDivideMenuSelected(e);
            app.PaintDivideMenu.Text = 'Divide';

            % Create PaintMixMenu
            app.PaintMixMenu = uimenu(app.PaintFcnMenu);
            app.PaintMixMenu.MenuSelectedFcn = @(o,e) app.PaintMixMenuSelected(e);
            app.PaintMixMenu.Text = 'Mix';

            % Create ValidateFcnMenu
            app.ValidateFcnMenu = uimenu(app.UIFigure);
            app.ValidateFcnMenu.Text = 'ValidateFcn';

            % Create ValidateIdentityMenu
            app.ValidateIdentityMenu = uimenu(app.ValidateFcnMenu);
            app.ValidateIdentityMenu.MenuSelectedFcn = @(o,e) app.ValidateIdentityMenuSelected(e);
            app.ValidateIdentityMenu.Text = 'Identity';

            % Create BrushFunctionsPanel

            % Create DistanceFcnLabel
            app.DistanceFcnLabel = uicontrol(app.UIFigure,'Style','text');
            app.DistanceFcnLabel.HorizontalAlignment = 'right';
            app.DistanceFcnLabel.Position = [8 138 72 22];
            app.DistanceFcnLabel.String = 'DistanceFcn';

            % Create CutOffFcnLabel
            app.CutOffFcnLabel = uicontrol(app.UIFigure,'Style','text');
            app.CutOffFcnLabel.HorizontalAlignment = 'right';
            app.CutOffFcnLabel.Position = [20 98 60 22];
            app.CutOffFcnLabel.String = 'CutOffFcn';

            % Create PaintFcnLabel
            app.PaintFcnLabel = uicontrol(app.UIFigure,'Style','text');
            app.PaintFcnLabel.HorizontalAlignment = 'right';
            app.PaintFcnLabel.Position = [27 60 53 22];
            app.PaintFcnLabel.String = 'PaintFcn';

            % Create ValidateFcnLabel
            app.ValidateFcnLabel = uicontrol(app.UIFigure,'Style','text');
            app.ValidateFcnLabel.HorizontalAlignment = 'right';
            app.ValidateFcnLabel.Position = [12 22 68 22];
            app.ValidateFcnLabel.String = 'ValidateFcn';

            % Create CutOffFcn
            app.CutOffFcn = uicontrol(app.UIFigure,'Style','edit');
            app.CutOffFcn.Callback = @(o,e) app.CutOffFcnValueChanged(e);
            app.CutOffFcn.HorizontalAlignment = 'center';
            app.CutOffFcn.Position = [137 98 185 22];
            app.CutOffFcn.String = 'D';

            % Create DistanceFcn
            app.DistanceFcn = uicontrol(app.UIFigure,'Style','edit');
            app.DistanceFcn.Callback = @(o,e) app.DistanceFcnValueChanged(e);
            app.DistanceFcn.HorizontalAlignment = 'center';
            app.DistanceFcn.Position = [137 138 185 22];
            app.DistanceFcn.String = 'vecnorm(V,2,2)';

            % Create PaintFcn
            app.PaintFcn = uicontrol(app.UIFigure,'Style','edit');
            app.PaintFcn.Callback = @(o,e) app.PaintFcnValueChanged(e);
            app.PaintFcn.HorizontalAlignment = 'center';
            app.PaintFcn.Position = [137 60 185 22];
            app.PaintFcn.String = 'B';

            % Create ValidateFcn
            app.ValidateFcn = uicontrol(app.UIFigure,'Style','edit');
            app.ValidateFcn.Callback = @(o,e) app.ValidateFcnValueChanged(e);
            app.ValidateFcn.HorizontalAlignment = 'center';
            app.ValidateFcn.Position = [137 22 185 22];
            app.ValidateFcn.String = 'V';

            % Create ValidateFcnSignature
            app.ValidateFcnSignature = uicontrol(app.UIFigure,'Style','text');
            app.ValidateFcnSignature.HorizontalAlignment = 'right';
            app.ValidateFcnSignature.Position = [96 22 34 22];
            app.ValidateFcnSignature.String = '@(V)';

            % Create PaintFcnSignature
            app.PaintFcnSignature = uicontrol(app.UIFigure,'Style','text');
            app.PaintFcnSignature.HorizontalAlignment = 'right';
            app.PaintFcnSignature.Position = [87 60 43 22];
            app.PaintFcnSignature.String = '@(P,B)';

            % Create CutOffFcnSignature
            app.CutOffFcnSignature = uicontrol(app.UIFigure,'Style','text');
            app.CutOffFcnSignature.HorizontalAlignment = 'right';
            app.CutOffFcnSignature.Position = [95 98 35 22];
            app.CutOffFcnSignature.String = '@(D)';

            % Create DistanceFcnSignature
            app.DistanceFcnSignature = uicontrol(app.UIFigure,'Style','text');
            app.DistanceFcnSignature.HorizontalAlignment = 'right';
            app.DistanceFcnSignature.Position = [96 138 34 22];
            app.DistanceFcnSignature.String = '@(V)';

            % Create BrushDataPanel
            CreateAxes3D(app.UIFigure);
            createValueBar(app);
            createStrengthBar(app);
            % Create RadiusLabel
            app.RadiusLabel = uicontrol(app.UIFigure,'Style','text');
            app.RadiusLabel.HorizontalAlignment = 'right';
            app.RadiusLabel.Position = [20 198 60 22];
            app.RadiusLabel.String = 'Radius';
            
            % Create Radius
            app.Radius = uicontrol(app.UIFigure,'Style','edit');
            app.Radius.Callback = @(o,e) app.RadiusValueChanged(str2double(o.String));
            app.Radius.HorizontalAlignment = 'center';
            app.Radius.Position = [137 198 185 22];
            app.Radius.String = '1';
            
            addlistener(app.Parent.WeightBrush,'RadiusChanged',@(varargin) set(app.Radius,'String',num2str(app.Parent.WeightBrush.Radius)));
        end
        
        function createValueBar(obj)
            h  = colorbar(handle(gca),...
                'Ticks',linspace(0,1,11),...
                'Position',[0.1 0.85 0.8 0.05],...
                'Location','north');
            h.Label.String = 'Value';
            a = annotation('line',...
                'Color',Green(),...
                'LineWidth',2,...
                'X', repmat(h.Position(1)+0.5*h.Position(3),1,2),...
                'Y',[h.Position(2) sum(h.Position([2,4]))],...
                'HitTest','off',...
                'PickableParts','none',...
                'HandleVisibility','off');
            h.ButtonDownFcn = @(o,e) cellfun(@(x) feval(x,o,e),...
                {...
                 @(o,e) set(a, 'X', repmat(h.Position(1)+e.IntersectionPoint(1)*h.Position(3),1,2)),...
                 @(o,e) obj.ValueValueChanged(e.IntersectionPoint(1))...
                },'UniformOutput',false);
            h.DeleteFcn  = @(varargin) delete(a);
            obj.ValueBar = h;
            
            addlistener(obj.Parent.WeightBrush,...
                'ValueChanged',...
                @(varargin) set(a, 'X', repmat(h.Position(1)+obj.Parent.WeightBrush.Value*h.Position(3),1,2)));
            obj.Value    = a;
            
            colormap(h,cmap('king',256));
        end
        
        function createStrengthBar(obj)
            h  = colorbar(handle(gca),...
                'Ticks',linspace(0,1,11),...
                'Position',[0.1 0.65 0.8 0.05],...
                'Location','north');
            h.Label.String = 'Strength';
            a = annotation('line',...
                'Color',Green(),...
                'LineWidth',2,...
                'Y',[h.Position(2) sum(h.Position([2,4]))],...
                'X', repmat(h.Position(1)+0.5*h.Position(3),1,2),...
                'HitTest','off',...
                'PickableParts','none',...
                'HandleVisibility','off');
            h.ButtonDownFcn = @(o,e) cellfun(@(x) feval(x,o,e),...
                {...
                 @(o,e) set(a, 'X', repmat(h.Position(1)+e.IntersectionPoint(1)*h.Position(3),1,2)),...
                 @(o,e) obj.StrengthValueChanged(e.IntersectionPoint(1))...
                },'UniformOutput',false);
            h.DeleteFcn     = @(varargin) delete(a);
            obj.StrengthBar = h;
            addlistener(obj.Parent.WeightBrush,...
                'StrengthChanged',...
                @(varargin) set(a, 'X', repmat(h.Position(1)+obj.Parent.WeightBrush.Strength*h.Position(3),1,2)));
            obj.Strength    = a;
            colormap(h,cmap('black',256));
        end
    end

    methods (Access = public)

        % Construct app
        function app = AbstractBrushUI(varargin)
            app@SharedDataComponent(varargin{:});
            setProps(app,'WeightBrush',AbstractBrushBase('Value',0.5));

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
%             registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)
            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
        
        function registerProps(app)
            addProps(app,'WeightBrush');
        end
    end
end