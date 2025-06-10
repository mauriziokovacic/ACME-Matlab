classdef MyBrush < handle
    properties( Access = public, SetObservable )
        Radius
        Strenght
        Value
        Position
        DistanceFcn
        PaintFcn
        CutOffFcn
        ValidateFcn
    end
    
    properties( Access = private, Hidden = true )
        DFcn
        PFcn
        CFcn
        VFcn
    end
    
    events
        BrushChanged
    end
    
    methods( Access = public )
        function [obj] = MyBrush(varargin)
            expectedPaintFcn  = {'add','sub','mul','div','mix'};
            expectedCutOffFcn = {'fixed','linear','quadratic','cubic','gauss','wyvill'};
            parser = inputParser;
            addParameter( parser, 'Radius',            0, @(h) isscalar(h)&&(h>=0));
            addParameter( parser, 'Strenght',        0.5, @(h) isscalar(h)&&(h>=0)&&h(h<=1));
            addParameter( parser, 'Value',            [], @(h) isnumeric(h));
            addParameter( parser, 'Position',         [], @(h) isnumeric(h));
            addParameter( parser, 'DistanceFcn',       2, @(h) (isscalar(h)&&(h>0))||(isa(h,'function_handle')));
            addParameter( parser, 'PaintFcn',      'mix', @(x) any(validatestring(x,expectedPaintFcn))||(isa(x,'function_handle')));
            addParameter( parser, 'CutOffFcn',  'linear', @(x) any(validatestring(x,expectedCutOffFcn))||(isa(x,'function_handle')));
            addParameter( parser, 'ValidateFcn',      [], @(x) isempty(x)||isa(x,'function_handle'));
            parse(parser,varargin{:});
            addlistener(obj,'DistanceFcn', 'PostSet',@obj.check_distance);
            addlistener(obj,'PaintFcn',    'PostSet',@obj.check_paint);
            addlistener(obj,'CutOffFcn',   'PostSet',@obj.check_cutoff);
            addlistener(obj,'ValidateFcn', 'PostSet',@obj.check_validate);
            obj.Radius   = parser.Results.Radius;
            obj.Strenght = parser.Results.Strenght;
            obj.Value    = parser.Results.Value;
            obj.Position = parser.Results.Position;
            if( isscalar(parser.Results.DistanceFcn) )
                obj.DistanceFcn = parser.Results.DistanceFcn;
            else
                obj.DistanceFcn = @parser.Results.DistanceFcn;
            end
            if( isstring(parser.Results.PaintFcn) || ischar(parser.Results.PaintFcn) )
                obj.PaintFcn = parser.Results.PaintFcn;
            else
                obj.PaintFcn = @parser.Results.PaintFcn;
            end
            if( isstring(parser.Results.CutOffFcn) || ischar(parser.Results.CutOffFcn) )
                obj.CutOffFcn = parser.Results.CutOffFcn;
            else
                obj.CutOffFcn = @parser.Results.CutOffFcn;
            end
            if( isempty(parser.Results.ValidateFcn) )
                obj.ValidateFcn = [];
            else
                obj.ValidateFcn = @parser.Results.ValidateFcn;
            end
        end
        
        function [obj] = copy(obj,h)
            name = fieldnames(obj);
            for i = 1 : numel(name)
                obj.(name{i}) = h.(name{i});
            end
%             obj.Radius      = h.Radius;
%             obj.Strenght    = h.Strenght;
%             obj.Value       = h.Value;
%             obj.Position    = h.Position;
%             obj.DistanceFcn = h.DistanceFcn;
%             obj.PaintFcn    = h.PaintFcn;
%             obj.CutOffFcn   = h.CutOffFcn;
%             obj.ValidateFcn = h.ValidateFcn;
        end
        
        function set(obj,propname,val)
            obj.(propname) = val;
            obj.Radius   = clamp(obj.Radius,0,Inf);
            obj.Strenght = clamp(obj.Strenght,0,1);
        end
        
        function setRadius(obj,val)
            obj.set('Radius',val);
        end
        
        function setStrenght(obj,val)
            obj.set('Strenght',val);
        end
        
        function setValue(obj,val)
            obj.set('Value',val);
        end
        
        function setPosition(obj,val)
            obj.set('Position',val);
        end

        function [out] = eval(obj,Position,Point,CurrentValue)
            out = CurrentValue;
            if(~obj.ready())
                return;
            end
            for i = 1 : row(Position)
                out = linint(out,...
                             obj.PFcn(out,obj.Value),...
                             obj.Strenght.*obj.CFcn(1-clamp(obj.DFcn(Point-Position(i,:))./obj.Radius,0,1)));
            end
            out = obj.VFcn(out);
        end
    end
    
    % Ready Function
    methods( Access = private, Hidden = true )
        function [tf] = ready(obj)
            tf = (~isempty(obj.Value))&&...
                 (~isempty(obj.Position))&&...
                 (~isempty(obj.Radius))&&...
                 (~isempty(obj.DFcn))&&...
                 (~isempty(obj.PFcn))&&...
                 (~isempty(obj.CFcn))&&...
                 (obj.Radius>=0);
        end
    end
    
    % CutOff Functions
    methods( Access = private, Hidden = true )
        function [out] = fixed(obj,Distance)
            out = Distance>0;
        end
        
        function [out] = linear(obj,Distance)
            out = Distance;
        end
        
        function [out] = quadratic(obj,Distance)
            out = Distance.^2;
        end
        
        function [out] = cubic(obj,Distance)
            out = Distance.^3;
        end
        
        function [out] = gauss(obj,Distance)
            out = normalize(gaussmf(Distance,[0.3333 1]),0,1);
        end
        
        function [out] = wyvill(obj,Distance)
            D2  = Distance.^2;
            D4  = D2.^2;
            D6  = D2.*D4;
            out = 1-clamp((9 - ( 4 .* D6 ) + ( 17 .* D4 )- ( 22 .* D2 ) ) ./ 9,0,1);
        end
    end
       
    % Paint Functions
    methods( Access = private, Hidden = true )
        function [out] = add(obj,CurrentValue,Value)
            out = CurrentValue+Value;
        end

        function [out] = sub(obj,CurrentValue,Value)
            out = CurrentValue-Value;
        end

        function [out] = mul(obj,CurrentValue,Value)
            out = CurrentValue.*Value;
        end

        function [out] = div(obj,CurrentValue,Value)
            out = CurrentValue./Value;
        end

        function [out] = mix(obj,~,Value)
            out = Value;
        end
    end
    
    % Check Functions
    methods( Access = private, Hidden = true )
        function check_distance(obj,varargin)
            if(isscalar(obj.DistanceFcn))
                if(obj.DistanceFcn>0)
                    obj.DFcn = @(d) vecnorm(d,obj.DistanceFcn,2);
                else
                    obj.DFcn = [];
                    error('Invalid DistanceFcn value. Value must be a positive real or Inf.');
                end
            else
                if(isa(obj.DistanceFcn,'function_handle'))
                    obj.DFcn = obj.DistanceFcn;
                else
                    obj.DFcn = [];
                    error('Invalid DistanceFcn value. Value must be a positive real or Inf, or a function handle.');
                end
            end
        end
        
        function check_paint(obj,varargin)
            expectedPaintFcn  = {'add','sub','mul','div','mix'};
            if(isstring(obj.PaintFcn)||ischar(obj.PaintFcn))
                if(any(validatestring(obj.PaintFcn,expectedPaintFcn)))
                    obj.PFcn = eval(strcat('@obj.',obj.PaintFcn));
                else
                    obj.PFcn = [];
                    error('Invalid PaintFcn value. Value must be ''add'',''sub'',''mul'',''div'',''mix'' or a function handle.');
                end
            else
                if(isa(obj.PaintFcn,'function_handle'))
                    obj.PFcn = obj.PaintFcn;
                else
                    obj.PFcn = [];
                    error('Invalid PaintFcn value. Value must be ''add'',''sub'',''mul'',''div'',''mix'' or a function handle.');
                end
            end
        end

        function check_cutoff(obj,varargin)
            expectedCutOffFcn = {'fixed','linear','quadratic','cubic','gauss','wyvill'};
            if(isstring(obj.CutOffFcn)||ischar(obj.CutOffFcn))
                if(any(validatestring(obj.CutOffFcn,expectedCutOffFcn)))
                    obj.CFcn = eval(strcat('@obj.',obj.CutOffFcn));
                else
                    obj.CFcn = [];
                    error('Invalid PaintFcn value. Value must be ''fixed'',''linear'',''quadratic'',''cubic'',''gauss'',''wyvill'' or a function handle.');
                end
            else
                if(isa(obj.CutOffFcn,'function_handle'))
                    obj.CFcn = obj.CutOffFcn;
                else
                    obj.CFcn = [];
                    error('Invalid PaintFcn value. Value must be ''fixed'',''linear'',''quadratic'',''cubic'',''gauss'',''wyvill'' or a function handle.');
                end
            end
        end
        
        function check_validate(obj,varargin)
            if(isempty(obj.ValidateFcn))
                obj.VFcn = @(x) x;
                return;
            end
            if(isa(obj.ValidateFcn,'function_handle'))
                obj.VFcn = obj.ValidateFcn;
                return;
            end
            error('Invalid ValidateFcn value. Value must be [] or a function handle.');
        end
    end
    
    methods( Access = public, Static )
        function [obj] = AssignBrush(val)
            obj = MyBrush('Radius',1,'Value',val,'CutOffFcn','fixed','PaintFcn','mix','Strenght',1,'ValidateFcn',[]);
        end
        
        function [obj] = WeightBrush(val)
            obj = MyBrush('Radius',1,'Value',val,'CutOffFcn','linear','PaintFcn','add','Strenght',0.1);
            obj.ValidateFcn = @(x) clamp(x,0,1);
        end
        
        function [obj] = PositionBrush(val)
            obj = MyBrush('Radius',1,'Value',val,'CutOffFcn','fixed','PaintFcn','mix','Strenght',0.1);
%             obj.ValidateFcn = @(x) clamp(x,[0 0 0],[1 1 1]);
        end
        
        function [obj] = NormalBrush(val)
            obj = MyBrush('Radius',1,'Value',val,'CutOffFcn','fixed','Strenght',0.1);
            obj.PaintFcn    = @(c,n) sign_of(sum(c.*n,2)) .* n;
            obj.ValidateFcn = @(n) normr(n);
        end
        
        function [obj] = FoldMoveBrush(val)
            obj = MyBrush('Radius',1,'Value',val,'CutOffFcn','linear','Strenght',0.1);
            function [F] = moveFold(W,w)
                h         = w;
                hbar      = setdiff((1:col(W))',h);
                F         = W;
                F(:,h   ) = (F(:,h   )./sum(F(:,h   ),2)).*0.5;
                F(:,hbar) = (F(:,hbar)./sum(F(:,hbar),2)).*0.5;
            end
            obj.PaintFcn    = @moveFold;
            obj.ValidateFcn = @(x) x./sum(x,2);
        end
        
        function [obj] = FoldAssignBrush(val)
            obj = MyBrush('Radius',1,'Value',val,'CutOffFcn','linear','Strenght',0.1);
            function [F] = assignFold(W,w)
                h         = find(w);
                hbar      = setdiff((1:col(W))',h);
                F         = W;
                F(:,h   ) = w(:,h);
                F(:,hbar) = (F(:,hbar)./sum(F(:,hbar),2)).*0.5;
            end
            obj.PaintFcn    = @assignFold;
            obj.ValidateFcn = @(x) x./sum(x,2);
        end
    end
end