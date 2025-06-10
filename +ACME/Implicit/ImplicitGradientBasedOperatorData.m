classdef ImplicitGradientBasedOperatorData < handle
    properties( Access = private, Hidden = true )
        F
        dF
    end
    
    methods( Access = public )
        function [self] = ImplicitGradientBasedOperatorData(V)
            [f1,f2,theta] = ndgrid(linspace(0,1,size(V, 1)),...
                                   linspace(0,1,size(V, 2)),...
                                   linspace(0,1,size(V, 3)));
            [df2, df1] = gradient(V, 1/size(V,1), 1/size(V,2), 1/size(V,3));
            dV = df1;
            dV = dV ./ (df1 + df2);
            dV(1,1,:) = zeros(size(dV,3),1);
            dV(end,end,:) = repmat(0.5,size(dV,3),1);
            self.F  = griddedInterpolant(f1, f2, theta,  V, 'linear', 'nearest');
            self.dF = griddedInterpolant(f1, f2, theta, dV, 'linear', 'nearest');
        end
        
        function [varargout] = fetch(self, y1, y2, theta)
            if nargout == 0
                return;
            end
            if nargout >= 1
                    varargout{1} = self.F(y1,y2,theta);
            end
            if nargout >= 2
                varargout{2} = self.dF(y1,y2,theta);
            end
            if nargout >= 3
                varargout{3} = 1-varargout{2};
            end
        end
    end
end