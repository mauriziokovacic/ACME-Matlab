classdef AbstractBrushBase < handle
    properties( Access = public, SetObservable )
        Radius
        Strength
        Value
        DistanceFcn
        PaintFcn
        CutOffFcn
        ValidateFcn
    end
    
    events
        BrushChanged
        RadiusChanged
        StrengthChanged
        ValueChanged
        DistanceFcnChanged
        PaintFcnChanged
        CutOffFcnChanged
        ValidateFcnChanged
    end
    
    methods( Access = public )
        function [obj] = AbstractBrushBase(varargin)
            expectedPaintFcn  = {'add','sub','mul','div','mix'};
            expectedCutOffFcn = {'fixed','linear','quadratic','cubic','gauss','wyvill'};
            parser = inputParser;
            addParameter( parser, 'Radius',       1,                   @(x) isscalar(x)&&(x>=0));
            addParameter( parser, 'Strength',     0.5,                 @(x) isscalar(x)&&(x>=0)&&(x<=1));
            addParameter( parser, 'Value',        [],                  @(x) isnumeric(x));
            addParameter( parser, 'DistanceFcn',  @(x) vecnorm(x,2,2), @(x) (isscalar(x)&&(h>x))||(isa(x,'function_handle')));
            addParameter( parser, 'PaintFcn',     @(a,b) b,            @(x) any(validatestring(x,expectedPaintFcn))||(isa(x,'function_handle')));
            addParameter( parser, 'CutOffFcn',    @(x) x,              @(x) any(validatestring(x,expectedCutOffFcn))||(isa(x,'function_handle')));
            addParameter( parser, 'ValidateFcn',  @(x) x,              @(x) isempty(x)||isa(x,'function_handle'));
            parse(parser,varargin{:});

            addlistener(obj,'Radius',     'PostSet',@(varargin) checkRadius(obj));
            addlistener(obj,'Strength',   'PostSet',@(varargin) checkStrength(obj));
            addlistener(obj,'DistanceFcn','PostSet',@(varargin) checkDistanceFcn(obj));
            addlistener(obj,'CutOffFcn',  'PostSet',@(varargin) checkCutOffFcn(obj));
            addlistener(obj,'PaintFcn',   'PostSet',@(varargin) checkPaintFcn(obj));
            addlistener(obj,'ValidateFcn','PostSet',@(varargin) checkValidateFcn(obj));
            
            name = fieldnames(obj);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
                addlistener(obj,name{i},'PostSet',@(varargin) notify(obj,'BrushChanged'));
                addlistener(obj,name{i},'PostSet',@(varargin) notify(obj,[name{i},'Changed']));
            end
        end
        
        function [obj] = copy(obj,h)
            name = fieldnames(obj);
            for i = 1 : numel(name)
                obj.(name{i}) = h.(name{i});
            end
        end
        
        function set(obj,propname,val)
            obj.(propname) = val;
            obj.Radius     = clamp(obj.Radius,0,Inf);
            obj.Strength   = clamp(obj.Strength,0,1);
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
                warning('Brush not properly set');
                return;
            end
            s = obj.Strength.^2;
            for i = 1 : row(Position)
                t   = obj.DistanceFcn(Point-Position(i,:));
                t   = obj.CutOffFcn(1-clamp(t./obj.Radius,0,1));
                t   = s .* t;
                out = linint(out,obj.PaintFcn(out,obj.Value),t);
            end
            out = obj.ValidateFcn(out);
        end
    end
    
    % Check Function
    methods( Access = private, Hidden = true )
        function [tf] = ready(obj)
            tf = (~isempty(obj.Value))&&...
                 (~isempty(obj.Radius))&&...
                 (~isempty(obj.DistanceFcn))&&...
                 (~isempty(obj.PaintFcn))&&...
                 (~isempty(obj.CutOffFcn))&&...
                 (~isempty(obj.ValidateFcn))&&...
                 (obj.Radius>=0);
        end
        
        function checkRadius(obj)
            r = obj.Radius;
            if(isempty(r))
                obj.Radius = 0;
                return;
            end
            if(~isscalar(r) || isa(r,'function_handle'))
                error(['Invalid Radius type. Type must be scalar. Got ',class(r),' instead.']);
            end
            if(isscalar(r))
            	if(r>=0)
                    return;
                else
                    r(r<0) = 0;
                    obj.Radius = r;
                    return;
                end
            end
            error(['Invalid Radius type. Type must be scalar. Got ',class(r),' instead.']);
        end
        
        function checkStrength(obj)
            s = obj.Strength;
            if(isempty(s))
                obj.Strength = 0;
                return;
            end
            if(~isscalar(s) || isa(s,'function_handle'))
                error(['Invalid Strength type. Type must be scalar. Got ',class(s),' instead.']);
            end
            if(isscalar(s))
            	if((s>=0)&&(s<=1))
                    return;
                else
                    obj.Strength = clamp(s,0,1);
                    return;
                end
            end
            error(['Invalid Strength type. Type must be scalar. Got ',class(s),' instead.']);
        end
        
        function checkDistanceFcn(obj)
            fun = obj.DistanceFcn;
            if(isempty(fun))
                fun = 2;
            end
            if(~isa(fun,'function_handle'))
                if(isscalar(fun))
                    if(fun>0)
                        fun = @(x) vecnorm(x,fun,2);
                    else
                        error(['Invalid DistanceFcn value. Expecting a positive scalar, greater than 0. Got ',num2str(fun),' instead.']);
                    end
                else
                    if(ischar(fun))
                        fun = lower(fun);
                        switch fun
                            case 'manhattan'
                                fun = @(x) vecnorm(x,1,2);
                            case 'euclidean'
                                fun = @(x) vecnorm(x,2,2);
                            case 'max'
                                fun = @(x) vecnorm(x,Inf,2);
                            otherwise
                                error(['Invalid DistanceFcn value. Expecting a known norm name: ''manhattan'', ''euclidean'', ''max''. Got ',fun,' instead.']);
                        end
                    else
                        error(['Invalid DistanceFcn type. Expecting a function handle, a positive scalar or a char vector. Got ',class(fun),' instead.']);
                    end
                end
                obj.DistanceFcn = fun;
            else
                if(nargin(fun)~=1)
                    error(['Invalid DistanceFcn signature. Expecting one input parameter. Got ',num2str(nargin(fun)),' instead.']);
                end
            end
        end
        
        function checkCutOffFcn(obj)
            fun = obj.CutOffFcn;
            if(isempty(fun))
                fun = 'linear';
            end
            if(~isa(fun,'function_handle'))
                if(ischar(fun))
                    fun = lower(fun);
                    switch fun
                        case 'fixed'
                            fun = @(x) x>0;
                        case 'linear'
                            fun = @(x) x;
                        case 'quadratic'
                            fun = @(x) x.^2;
                        case 'cubic'
                            fun = @(x) x.^3;
                        case 'gauss'
                            fun = @(x) normalize(gaussmf(x,[0.3333 1]),0,1);
                        case 'wyvill'
                            fun = @(x) wyvill(x);
                        otherwise
                            error(['Invalid CutOffFcn value. Expecting a known norm name: ''fixed'', ''linear'', ''quadratic'', ''cubic'', ''gauss'', ''wyvill''. Got ',fun,' instead.']);
                    end
                else
                    error(['Invalid CutOffFcn type. Expecting a function handle or a known norm name: ''fixed'', ''linear'', ''quadratic'', ''cubic'', ''gauss'', ''wyvill''. Got ',class(fun),' instead.']);
                end
                obj.CutOffFcn = fun;
            else
                if(nargin(fun)~=1)
                    error(['Invalid CutOffFcn signature. Expecting one input parameter. Got ',num2str(nargin(fun)),' instead.']);
                end
            end
        end
        
        function checkPaintFcn(obj)
            fun = obj.PaintFcn;
            if(isempty(fun))
                fun = 'mix';
            end
            if(~isa(fun,'function_handle'))
                if(ischar(fun))
                    fun = lower(fun);
                    fun = fun(1:3);
                    switch fun
                        case 'add'
                            fun = @(p,x) p+x;
                        case 'sub'
                            fun = @(p,x) p-x;
                        case 'mul'
                            fun = @(p,x) p.*x;
                        case 'div'
                            fun = @(p,x) p./x;
                        case 'mix'
                            fun = @(~,x) x;
                        otherwise
                            error(['Invalid PaintFcn value. Expecting a known norm name: ''add'', ''sub'', ''mul'', ''div'', ''mix''. Got ',fun,' instead.']);
                    end
                else
                    error(['Invalid PaintFcn type. Expecting a function handle or a known norm name: ''add'', ''sub'', ''mul'', ''div'', ''mix''. Got ',class(fun),' instead.']);
                end
                obj.PaintFcn = fun;
            else
                if(nargin(fun)~=2)
                    error(['Invalid PaintFcn signature. Expecting two input parameter. Got ',num2str(nargin(fun)),' instead.']);
                end
            end
        end
        
        function checkValidateFcn(obj)
            fun = obj.ValidateFcn;
            if(isempty(fun))
                fun = 'mix';
            end
            if(~isa(fun,'function_handle'))
                if(ischar(fun))
                    fun = lower(fun);
                    switch fun
                        case 'identity'
                            fun = @(x) x;
                        otherwise
                            error(['Invalid ValidateFcn value. Expecting a known norm name: ''identity''. Got ',fun,' instead.']);
                    end
                else
                    error(['Invalid ValidateFcn type. Expecting a function handle or a known norm name: ''identity''. Got ',class(fun),' instead.']);
                end
                obj.ValidateFcn = fun;
            else
                if(nargin(fun)~=1)
                    error(['Invalid ValidateFcn signature. Expecting one input parameter. Got ',num2str(nargin(fun)),' instead.']);
                end
            end
        end
    end    
end