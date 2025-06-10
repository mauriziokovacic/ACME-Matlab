classdef MyBrushUI < SharedDataComponent

    % Properties that correspond to app components
    properties (Access = private)
        UIFigure                
        TabGroup                matlab.ui.container.TabGroup
        BasicTab                matlab.ui.container.Tab
        SettingsPanel           matlab.ui.container.Panel
        ValueEditFieldLabel     matlab.ui.control.UIControl
        Value                   matlab.ui.control.UIControl
        RadiusEditFieldLabel    matlab.ui.control.UIControl
        Radius                  matlab.ui.control.UIControl
        StrenghtSpinnerLabel    matlab.ui.control.UIControl
        Strenght                matlab.ui.control.UIControl
        PaintFcnButtonGroup     matlab.ui.container.ButtonGroup
        SelectPaintAdd          matlab.ui.control.UIControl
        SelectPaintSub          matlab.ui.control.UIControl
        SelectPaintMul          matlab.ui.control.UIControl
        SelectPaintDiv          matlab.ui.control.UIControl
        SelectPaintMix          matlab.ui.control.UIControl
        SelectPaintCustom       matlab.ui.control.UIControl
        PaintCustom             matlab.ui.control.UIControl
        AdvancedTab             matlab.ui.container.Tab
        DistanceFcnButtonGroup  matlab.ui.container.ButtonGroup
        SelectDistanceExp       matlab.ui.control.UIControl
        SelectDistanceCustom    matlab.ui.control.UIControl
        DistanceCustom          matlab.ui.control.UIControl
        DistanceExponent        matlab.ui.control.UIControl
        CutOffFcnButtonGroup    matlab.ui.container.ButtonGroup
        SelectCutOffFixed       matlab.ui.control.UIControl
        SelectCutOffLinear      matlab.ui.control.UIControl
        SelectCutOffQuadratic   matlab.ui.control.UIControl
        SelectCutOffCubic       matlab.ui.control.UIControl
        SelectCutOffGauss       matlab.ui.control.UIControl
        SelectCutOffWyvill      matlab.ui.control.UIControl
        SelectCutOffCustom      matlab.ui.control.UIControl
        CutOffCustom             matlab.ui.control.UIControl
    end


    properties (Access = public, SetObservable)
        Target % Target brush
    end

    methods (Access = private )
        function update(app,varargin)
            setProps(app,'WeightBrush',app.Target);
        end
    end
    
    methods (Access = public )
        function registerProps(app)
            addProps(app,'WeightBrush');
        end
    end


    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.Target = MyBrush.WeightBrush(0.5);
        end

        % Value changed function: Value
        function ValueChanged(app, varargin)
            value = eval(app.Value.String);
            app.Target.Value = value;
            update(app);
        end

        % Value changed function: Radius
        function RadiusChanged(app, varargin)
            value = str2double(app.Radius.String);
            app.Target.Radius = value;
            update(app);
        end

        % Value changed function: Strenght
        function StrenghtChanged(app, varargin)
            value = str2double(app.Strenght.String);
            app.Target.Strenght = value;
            update(app);
        end

        % Selection changed function: PaintFcnButtonGroup
        function PaintFcnChanged(app, varargin)
            selectedButton = app.PaintFcnButtonGroup.SelectedObject;
            selectedButton = selectedButton.String;
            if( isempty(selectedButton) )
                app.Target.PaintFcn = eval(['@(x) ',app.PaintCustom.String]);
            else
                selectedButton = lower(selectedButton(1:3));
                app.Target.PaintFcn = selectedButton;
            end
            update(app);
        end

        % Selection changed function: DistanceFcnButtonGroup
        function DistanceFcnChanged(app, varargin)
            selectedButton = app.DistanceFcnButtonGroup.SelectedObject;
            selectedButton = selectedButton.Tag;
            if( strcmpi(selectedButton,'1') )
                app.Target.DistanceFcn = str2double(app.DistanceExponent);
            else
                app.Target.DistanceFcn = eval(['@(x) ',app.DistanceCustom.String]);
            end
            update(app);
        end

        % Selection changed function: CutOffFcnButtonGroup
        function CutOffFcnChanged(app, varargin)
            selectedButton = app.CutOffFcnButtonGroup.SelectedObject;
            selectedButton = selectedButton.String;
            if( isempty(selectedButton) )
                app.Target.CutOffFcn = eval(['@(x) ',app.CutOffCustom.String]);
            else
                selectedButton = lower(selectedButton);
                app.Target.CutOffFcn = selectedButton;
            end
            update(app);
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = figure('MenuBar','none','ToolBar','none','NumberTitle','off','Resize','off');
            app.UIFigure.Position = [100 100 212 369];
            app.UIFigure.Name = 'Brush UI';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure,'Units','normalized');
            app.TabGroup.Position = [0 0 1 1];

            % Create BasicTab
            createBasicTab(app);

            % Create AdvancedTab
            createAdvancedTab(app);
        end
        
        function createBasicTab(app)
            % Create BasicTab
            app.BasicTab = uitab(app.TabGroup,'Title','Basic');
            createSettingsGroup(app,app.BasicTab);
            createPaintFcnGroup(app,app.BasicTab);
        end
        
        function createSettingsGroup(app,tab)
            % Create SettingsPanel
            app.SettingsPanel = uipanel(tab,...
                'Units','normalized',...
                'Title','Settings',...
                'Position',[0 0.7 1 0.3]);
            createSettingsGroupComponent(app,app.SettingsPanel);
        end
        
        function createSettingsGroupComponent(app,group)
            % Create ValueEditFieldLabel
            [app.ValueEditFieldLabel,app.Value] = createLabelValuePair(app,group,'Value',0.7);
            app.Value.Callback = @app.ValueChanged;
            app.Value.String = '0.5';

            % Create RadiusEditFieldLabel
            [app.RadiusEditFieldLabel,app.Radius] = createLabelValuePair(app,group,'Radius',0.4);
            app.Radius.Callback = @app.RadiusChanged;
            app.Radius.String = '1';

            % Create StrenghtSpinnerLabel
            [app.StrenghtSpinnerLabel,app.Strenght] = createLabelValuePair(app,group,'Strength',0.1);
            app.Strenght.Callback = @app.StrenghtChanged;
            app.Strenght.String = '0.5';
        end
        
        function [l,v] = createLabelValuePair(app,parent,text,y)
            h = 0.2;
            x = 0;
            l = uicontrol(parent,...
                'Style','text',...
                'Units','normalized',...
                'String',text,...
                'HorizontalAlignment','right',...
                'Position',[x y 0.2 h]);
            v = uicontrol(parent,...
                'Style','edit',...
                'Units','normalized',...
                'Position',[x+0.3 y 0.6 h]);
        end
        
        function createPaintFcnGroup(app,tab)
            % Create PaintFcnButtonGroup
            app.PaintFcnButtonGroup = uibuttongroup(tab,...
                'Units','normalized',...
                'Title','PaintFcn',...
                'Position',[0 0 1 0.7],...
                'SelectionChangedFcn',@app.PaintFcnChanged);
            createPaintFcnGroupComponent(app,app.PaintFcnButtonGroup);
        end
        
        function createPaintFcnGroupComponent(app,group)
            x = 0; h = 0.1; w = 1;
            str    = {'Add','Subtract','Multiply','Divide','Mix','@(x)'};
            prefix = 'SelectPaint';
            name   = {'Add','Sub','Mul','Div','Mix','Custom'};
            pos    = linspace(1-h,1-(h*numel(str)),numel(str));
            for i = 1 : numel(name)
                app.([prefix,name{i}]) = uicontrol(group,...
                'Style','radiobutton',...
                'Units','normalized',...
                'String',str{i},...
                'Position',[x pos(i) w h]);
            end
            % Create SelectPaintAdd
            app.SelectPaintAdd.Value = 1;
            % Create PaintCustom
            app.PaintCustom = uicontrol(group, 'Style','edit','Units','normalized');
            app.PaintCustom.Position = [0.2 pos(end) 0.72 h];
            app.PaintCustom.String = 'x';
        end
        
        function createAdvancedTab(app)
            % Create AdvancedTab
            app.AdvancedTab = uitab(app.TabGroup,'Title','Advanced');
            createDistanceFcnGroup(app,app.AdvancedTab);
            createCutOffFcnGroup(app,app.AdvancedTab);
        end
        
        function createDistanceFcnGroup(app,tab)
            % Create DistanceFcnButtonGroup
            app.DistanceFcnButtonGroup = uibuttongroup(tab,...
                'Units','normalized',...
                'SelectionChangedFcn',@app.DistanceFcnChanged,...
                'Title','DistanceFcn',...
                'Position',[0 0.7 1 0.3]);
            createDistanceFcnGroupComponent(app,app.DistanceFcnButtonGroup);
        end
        
        function createDistanceFcnGroupComponent(app,group)
            x = 0; h = 0.2; w = 1;
            str    = {'Norm','@(x)'};
            prefix = 'SelectDistance';
            name   = {'Exp','Custom'};
            pos    = linspace(1-h-0.2,1-0.2-(h*numel(str)),numel(str));
            for i = 1 : numel(name)
                app.([prefix,name{i}]) = uicontrol(group,...
                'Style','radiobutton',...
                'Units','normalized',...
                'String',str{i},...
                'Position',[x pos(i) 0.3 h]);
            end
            % Create SelectDistanceExp
            app.SelectDistanceExp.Value = 1;
            % Create DistanceExponent
            app.DistanceExponent = uicontrol(group, 'Style','edit','Units','normalized');
            app.DistanceExponent.Position = [0.25 pos(1) 0.62 h];
            app.DistanceExponent.String = '2';
            % Create DistanceCustom
            app.DistanceCustom = uicontrol(group, 'Style','edit','Units','normalized');
            app.DistanceCustom.Position = [0.25 pos(end) 0.62 h];
            app.DistanceCustom.String = 'x';
        end
        
        function createCutOffFcnGroup(app,tab)
            % Create createCutOffFcnButtonGroup
            app.CutOffFcnButtonGroup = uibuttongroup(tab,...
                'Units','normalized',...
                'SelectionChangedFcn',@app.CutOffFcnChanged,...
                'Title','CutOffFcn',...
                'Position',[0 0 1 0.7]);
            createCutOffFcnGroupComponent(app,app.CutOffFcnButtonGroup);
        end
        
        function createCutOffFcnGroupComponent(app,group)
            x = 0; h = 0.1; w = 1;
            str    = {'Fixed','Linear','Quadratic','Cubic','Gauss','Wyvill','@(x)'};
            prefix = 'SelectCutOff';
            name   = [str(1:end-1),{'Custom'}];
            pos    = linspace(1-h,1-(h*numel(str)),numel(str));
            for i = 1 : numel(name)
                app.([prefix,name{i}]) = uicontrol(group,...
                'Style','radiobutton',...
                'Units','normalized',...
                'String',str{i},...
                'Position',[x pos(i) w h]);
            end
            % Create SelectCutOffLinear
            app.SelectCutOffLinear.Value = 1;
            % Create CutOffCustom
            app.CutOffCustom = uicontrol(group, 'Style','edit','Units','normalized');
            app.CutOffCustom.Position = [0.2 pos(end) 0.72 h];
            app.CutOffCustom.String = 'x';
        end
    end

    methods (Access = public)

        % Construct app
        function [app] = MyBrushUI(varargin)
            app@SharedDataComponent(varargin{:});
            % Create and configure components
            createComponents(app);

            % Execute the startup function
            startupFcn(app);

            update(app);
            
            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)
            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end