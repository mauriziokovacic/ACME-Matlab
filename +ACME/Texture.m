classdef Texture
    properties
        Resolution
        Cell
    end
    
    methods
        function [obj] = Texture(varargin)
            Data = [];
            if( nargin >= 1 )
                S     = varargin{1};
                [U,V] = meshgrid(linspace(0,1,row(S)),linspace(0,1,col(S)));
                Data  = repmat(TextureCell(),row(S)-1,col(S)-1);
                for i = 1 : row(S)-1
                    for j = 1 : col(S)-1
                        Data(i,j) = TextureCell([U(i  ,j  ) V(i  ,j  );...
                                                 U(i  ,j+1) V(i  ,j+1);...
                                                 U(i+1,j  ) V(i+1,j  );...
                                                 U(i+1,j+1) V(i+1,j+1);],...
                                                [S(i,j);S(i,j+1);S(i+1,j);S(i+1,j+1)]);
                    end
                end
            end
            obj.Cell       = Data;
            obj.Resolution = log2(row(Data)+1);
        end
        
        function [tf] = valid(obj)
            tf = isempty(find(arrayfun(@(c) ~c.valid(), obj.Cell,'UniformOutput',false),1));
        end
        
        function [D] = fetch(obj,uv)
            D = zeros(row(uv),col(obj.Cell(1,1).Data));
            parfor i = 1 : row(uv)
                D(i,:) = obj.Cell(obj.uv2hash(uv(i,:))).fetch(uv(i,:));
            end
%             D = arrayfun(@(c,i) c.fetch(uv(i,:)), obj.Cell(obj.uv2hash(uv)), (1:row(uv))');
        end
        
    end
    
    
    
    methods
        function [h] = sub2hash(obj,i,j)
            h = sub2ind(size(obj.Cell),i,j);
        end
        
        function [h] = uv2hash(obj,uv)
            i = obj.uv2sub(uv);
            h = obj.sub2hash(i(:,1),i(:,2));
        end
        
        function [i] = uv2sub(obj,uv)
            i = clamp(uint32(clamp(uv,0,1).*(2^obj.Resolution-1)),...
                      1,...
                      2^obj.Resolution-1);
        end
    end
    
    
end