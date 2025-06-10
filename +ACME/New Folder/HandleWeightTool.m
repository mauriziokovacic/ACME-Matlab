classdef HandleWeightTool < SharedDataComponent
    properties( Access = protected, Hidden = true )
        handleListener
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = HandleWeightTool(varargin)
            obj@SharedDataComponent(varargin{:});
        end
    end
    
    methods( Access = public )
        function registerProps(obj)
            addProps(obj,'Skin');
            addProps(obj,'HandleIndex');
            addProps(obj,'Field');
            obj.handleListener = addPropListener(obj,...
                                               'HandleIndex',...
                                               @(varargin) selectHandle(obj));
        end
        
        function delete(obj)
            delete(obj.handleListener);
        end
    end
    
    methods( Access = public )
        function selectHandle(obj)
            M = getProps(obj,'Mesh');
            S = getProps(obj,'Skin');
            H = getProps(obj,'HandleIndex');
            if(isempty(H))
                W = zeros(row(M.Vertex),1);
            else
                W = full(sum(S.Weight(:,H),2));
            end
            setProps(obj,'Field',W);
        end
    end
end