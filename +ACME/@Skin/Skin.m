classdef Skin
    properties
        M        
        W
        
        P_
        N_
        W_
        I
    end
    
    methods
        function [obj] = Skin(varargin)
            obj.M  = [];
            obj.W  = [];
            obj.P_ = [];
            obj.N_ = [];
            obj.W_ = [];
            obj.I  = [];
            if( nargin >= 1 )
                obj.M = varargin{1};
            end
            if( nargin >= 2 )
                obj.W = varargin{2};
            end
            if( nargin >= 3 )
                obj.P_ = varargin{3};
            end
            if( nargin >= 4 )
                obj.N_ = varargin{4};
            end
            if( nargin >= 5 )
                obj.W_ = varargin{5};
            end
            if( nargin >= 6 )
                obj.I = varargin{6};
            end
        end
        
        [P ,N ]            = LBS(obj,Pose);
        [P ,N ]            = DQS(obj,Pose);
        [P ,N, varargout ] = CPS(obj,Pose,Op,varargin);
        [P ,N, varargout ] = COR(obj,Pose,CoR);
        [P ,N ]            = MAYA(obj,Pose);
    end
end