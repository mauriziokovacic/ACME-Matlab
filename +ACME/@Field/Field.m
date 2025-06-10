classdef Field < handle
    properties
        F
        gF
        dF
    end
    methods
        function obj = Field(varargin)
            if( ( nargin == 1 ) && isa(varargin{1},'Field') )
                obj.F = varargin{1}.F;
                obj.gF = varargin{1}.gF;
                obj.dF = varargin{1}.dF;
                return;
            end
            if( nargin >= 1 )
                obj.F = varargin{1};
            else
                obj.F = [];
            end
            if( nargin >= 2 )
                obj.gF = varargin{2};
            else
                obj.gF = [];
            end
            if( nargin >= 3 )
                obj.dF = varargin{3};
            else
                obj.dF = [];
            end
        end
        
        function obj = compute_gF(obj,P,T)
            obj.gF = compute_gradient(P,T,obj.F);
        end
        
        function obj = compute_dF(obj,P,T)
            obj.dF = compute_divergence(P,T,obj.gF);
        end
    end
end