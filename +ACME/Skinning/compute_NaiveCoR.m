function [CoR] = compute_NaiveCoR(M,S,varargin)
if( nargin == 4 )
    CoR = line_type(M.Vertex, S.Weight, varargin{1}, varargin{2});
    return;
end
if( nargin == 3 )
    CoR = skel_type(M, S, varargin{1});
end
end

function [CoR] = line_type(P, W, A, B)
CoR = cell2mat(arrayfun(@(i) W(i,:) * project_point_on_line(A, B, P(i,:)),...
                        (1:row(P))',...
                        'UniformOutput',false));
end

function [CoR] = skel_type(M, S, Skel)
[x,i] = project_on_bone(Skel,M.Vertex);
CoR   = cell2mat(arrayfun(@(k) S.Weight(k,i) * x{k}, (1:row(M.Vertex))', 'UniformOutput', false));
end