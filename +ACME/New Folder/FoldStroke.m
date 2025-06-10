classdef FoldStroke < AbstractStroke
    properties( Access = public, SetObservable )
        Skin
        Handle
    end
    
    methods( Access = public, Sealed = true )
        function [obj] = FoldStroke(varargin)
            obj@AbstractStroke(varargin{:});
            parser = inputParser;
            parser.KeepUnmatched = true;
            addParameter( parser, 'Skin',   [], @(data) isa(data,'AbstractSkin'));
            addParameter( parser, 'Handle', [], @(data) isnumeric(data));
            parse(parser,varargin{:});
            name = fieldnames(parser.Results);
            for i = 1 : numel(name)
                obj.(name{i}) = parser.Results.(name{i});
            end
        end
        
        function [h] = show(obj)
            h = [];
            color = scatter_color(numel(obj),(1:numel(obj))');
            for i = 1 : numel(obj)
                C = obj(i);
                P = C.Skin.Mesh.Vertex;
                h = [h;display_curve(P(C.Point,:), curveEdge(numel(C.Point)),'EdgeColor',color(i,:))];
            end
        end
        
        function [W] = apply(obj,P,T,W)
            % Input mesh data
%             P    = obj.Skin.Mesh.Vertex;
%             T    = obj.Skin.Mesh.Face;
%             W    = obj.Skin.Weight;
            for c = 1 : numel(obj)
                % Stroke data as vertex indices
                v    = obj(c).Point;

                % Handle sets
                h    = obj(c).Handle;
                hbar = setdiff((1:col(W))',h);

                % Stroke parameters
                u    = make_column(obj(c).Pressure);
                t    = obj(c).Strength;

                % Compute weights displacement
                dW         = W(v,:);
                dW(:,h   ) = (dW(:,h   )./sum(dW(:,h   ),2)).*0.5;
                dW(:,hbar) = (dW(:,hbar)./sum(dW(:,hbar),2)).*0.5;
                dW(~isfinite(dW)) = 0;
                dW         = u .* (dW-W(v,:));

                % Solve the diffusion problem to find solution
                [i,j,w]    = find(dW);
                A = add_constraints(barycentric_area(P,T)+t*cotangent_Laplacian(P,T),v,[]);
                b = sparse(v(i),j,w,row(W),col(W));
                W = W+linear_problem(A,b);

                % Impose partition of unity
                W = W./sum(W,2);
            end
        end
    end
    
    methods( Access = public )
        function [P] = getPoint(obj)
            P = obj.Skin.Mesh.Vertex(obj.Point,:);
        end
    end
end
