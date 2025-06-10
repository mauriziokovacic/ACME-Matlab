function [G] = skeletonGraph(varargin)
parser = inputParser;
addRequired(parser, 'NodeRelation', @(data) issparse(data)||isnumeric(data));
addParameter(parser, 'NodeName', [], @(data) iscell(data));
parse(parser,varargin{:});

node = parser.Results.NodeRelation;
name = parser.Results.NodeName;

if(issparse(node)&&~isvector(node))
    type = 'child';
else
    if(isvector(node))
        type = 'parent';
    else
        error('Node relation need to be a dense vector (node-parent relation) or a sparse matrix (node-child relation).');
    end
end

if(strcmpi(type,'parent'))
    node = sparse(node,(1:numel(node))',1,numel(node),numel(node));
end
G = digraph(node);

if(isempty(name))
    name = cell(numnodes(G),1);
    for i = 1 : numnodes(G)
        name{i} = 'Node';
        x = successors(G,i);
        if(isempty(x))
            name{i} = 'Leaf';
        end
        if(numel(x)==1)
            name{i} = 'Joint';
        end
        x = predecessors(G,i);
        if(isempty(x))
            name{i} = 'Root';
        end
        name{i} = [name{i},'-',num2str(i)];
    end
end
G.Nodes.Name = name;
end