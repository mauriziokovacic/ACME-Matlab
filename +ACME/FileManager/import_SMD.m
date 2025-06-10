function [Data] = import_SMD(varargin)
parser = inputParser;
addRequired(  parser, 'filename',        @(data) isstring(data)||ischar(data));
addParameter( parser, 'verbose',  false, @(data) islogical(data));
parse(parser,varargin{:});
filename  = parser.Results.filename;
verbose   = parser.Results.verbose;

    function [data,type] = readDataFcn(fileID)
        data = textscan(fileID,'%s','Delimiter',newline);
        data = data{1};
        if(~strcmpi(data{1},'version 1'))
            fclose(fileID);
            error('File is not a valid SMD.');
        end
        type = findContentType(data);
        if(strcmpi(type,'invalid'))
            fclose(fileID);
            error('File content is not valid.');
        end
    end

[buffer,type] = import_from_file(filename,'smd',@readDataFcn,verbose);
switch type
    case 'reference'
        [P,N,UV,T,W,S,R] = fecthReferenceData(buffer);
        Data = {'Type','Reference/Collision';...
                      'Point',P;...
                      'Normal',N;...
                      'UV',UV;...
                      'Triangle',T;...
                      'Weight',W;...
                      'Skeleton',S;...
                      'RestPose',R};
    case 'animation'
        [S,A] = fetchAnimationData(buffer);
        Data = {'Type','Animation';'Skeleton',S;'Animation',A};
    case 'vertex'
        [S,F] = fetchVertexAnimationData(buffer);
        Data = {'Type','Vertex Animation'; 'Skeleton', S; 'Flex', F};
end

end

function [P,N,UV,T,W,S,R] = fecthReferenceData(data)
i = findBlock(data,'nodes');
S = fetchSkeleton(data(i(1):i(2)));
i = findBlock(data,'skeleton');
R = fetchRestPose(data(i(1):i(2)));
i            = findBlock(data,'triangles');
[P,N,UV,T,W] = fetchTriangles(data(i(1):i(2)),numnodes(S));
end

function [S,A] = fetchAnimationData(data)
i = findBlock(data,'nodes');
S = fetchSkeleton(data(i(1):i(2)));
i = findBlock(data,'skeleton');
A = fetchKeyFrame(data(i(1):i(2)));
end

function [S,F] = fetchVertexAnimationData(data)
i = findBlock(data,'nodes');
S = fetchSkeleton(data(i(1):i(2)));
i = findBlock(data,'vertexanimation');
F = fetchVertexAnimation(data(i(1):i(2)));
end

function [i] = findBlock(data,block_name)
i = find(strcmp(data,block_name));
if(~isempty(i))
    i(2) = find(strcmp(data(i(1):end),'end'),1)+i(1)-1;
    i = i + [1 -1];
end
end

function [type] = findContentType(data)
type  = {'reference';'animation';'vertex';'invalid'};
check = {{'nodes','skeleton','triangles'};...
         {'nodes','skeleton'};...
         {'nodes','skeleton','vertexanimation'}};
for i = 1 : numel(type)
    if(i~=4)
        tf = true;
        for j = 1 : numel(check{i})
            tf = tf & ~isempty(findBlock(data,check{i}{j}));
        end
        if(tf)
            break;
        end
    end
end
type = type{i};
end

function [S] = fetchSkeleton(data)
data  = cellfun(@(c) strsplit(c),data,'UniformOutput',false);
nID   = cell2mat(cellfun(@(c) str2double(c{1})+1,data,'UniformOutput',false));
nName = cellfun(@(c) strrep(c{2},'"',''),data,'UniformOutput',false);
nPar  = cell2mat(cellfun(@(c) str2num(c{3})+1,data,'UniformOutput',false));
n     = numel(nID);
S     = skeletonGraph(sparse(nPar(nPar~=0),nID(nPar~=0),1,n,n),...
                      'NodeName',nName);
end

function [R] = fetchRestPose(data)
R = fetchKeyFrame(data);
R = R{1};
end

function [P,N,UV,T,W] = fetchTriangles(data,nNodes)
data(1:4:end) = [];
data = cellfun(@(c) str2num(c),data,'UniformOutput',false);
P    = cell2mat(cellfun(@(c) c(2:4),data,'UniformOutput',false));
N    = cell2mat(cellfun(@(c) c(5:7),data,'UniformOutput',false));
UV   = cell2mat(cellfun(@(c) c(8:9),data,'UniformOutput',false));
T    = reshape((1:row(P))',3,row(P)/3)';
W    = cellfun(@(c) c(11:end),data,'UniformOutput',false);
W    = cell2mat(arrayfun(@(i) [repmat(i,numel(W{i})/2,1) reshape(W{i},2,numel(W{i})/2)'], (1:row(W))', 'UniformOutput',false));
W    = sparse(W(:,1),W(:,2)+1,W(:,3),row(P),nNodes,row(W));
end

function [A] = fetchKeyFrame(data)
k = find(contains(data,'time'));
k = [k;row(data)+1];
k = [k(1:end-1) k(2:end)] + [1 -1];
A = cell(row(k),1);
for i = 1 : row(k)
    A{i} = fetchPose(data(k(i,1):k(i,2)));
end
end

function [Pose] = fetchPose(data)
data = cell2mat(cellfun(@(c) str2num(c),data,'UniformOutput',false));
ID   = data(:,1)+1;
T    = data(:,2:4);
R    = data(:,5:7);

% 2 1 3 almost works
o    = [2 1 3];
T    = [T(:,o(1)) T(:,o(2)) T(:,o(3))];
R    = [R(:,o(1)) R(:,o(2)) R(:,o(3))];

S    = [1 0 0; 0 1 0; 0 0 1];

T    = arrayfun(@(i) [zeros(3) T(i,:)'; zeros(1,4)],(1:row(ID))','UniformOutput',false);
R    = arrayfun(@(i) padarray((S*eul2rotm(R(i,:),'XYZ')*S),[1 1],'post'),(1:row(ID))','UniformOutput',false);
Pose = (arrayfun(@(i) (T{i}+R{i}+sparse(4,4,1,4,4)), (1:row(ID))','UniformOutput',false));
end

function [F] = fetchVertexAnimation(data)
k = find(contains(data,'time'));
k = [k;row(data)+1];
k = [k(1:end-1) k(2:end)] + [1 -1];
F = cell(row(k),1);
for i = 1 : row(k)
    F{i} = fetchFlexData(data(k(i,1):k(i,2)));
end
end

function [F] = fetchFlexData(data)
data = cell2mat(cellfun(@(c) str2num(c),data,'UniformOutput',false));
ID   = data(:,1)+1;
P    = data(:,2:4);
N    = data(:,5:7);
F    = struct('ID',ID,'Point',P,'Normal',N);
end