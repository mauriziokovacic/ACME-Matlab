classdef MatlabGoofCode
    properties
        % Prop(dim1,...,dimn) classType {fcn1,...,fcnm} = defaultValue
        A(1,2) double = [0 0];
        B(1,:) double {mustBeSameSize(B)} = [0 0];
    end
    
    methods
        function [obj] = MatlabGoofCode(varargin)
            % MATLABGOOFCODE  Create a Goof Code OBJ
            %   obj = MATLABGOOFCODE() returns something
            %
            %   obj = MATLABGOOFCODE(input) returns something else
        end
    end
end

function mustBeSameSize(a,b)
    if(numel(a)~=numel(b))
        error('B size must be equal to A');
    end
end