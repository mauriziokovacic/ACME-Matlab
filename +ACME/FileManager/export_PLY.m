function export_PLY(varargin)
parser = inputParser;
addRequired(  parser, 'filename', @(data) ~isempty(data)&&(ischar(data)||isstring(data)));
addParameter( parser, 'Point',      [], @(data) isnumeric(data));
addParameter( parser, 'Normal',     [], @(data) isnumeric(data));
addParameter( parser, 'UV',         [], @(data) isnumeric(data));
addParameter( parser, 'Color',      [], @(data) isnumeric(data));
addParameter( parser, 'Face',       [], @(data) isnumeric(data)||iscell(data));
addParameter( parser, 'verbose', false, @(data) islogical(data));
parse(parser,varargin{:});
filename = parser.Results.filename;
P  = parser.Results.Point;
N  = parser.Results.Normal;
UV = parser.Results.UV;
C  = parser.Results.Color;
F  = parser.Results.Face;
verbose = parser.Results.verbose;
if(~any(C>1))
    C = double(color2uint8(C));
end
header = ['ply',newline,'format ascii 1.0',newline];
header = [header,'element vertex ',num2str(row(P)),newline];
if(~isempty(P))
    header = [header,'property float x',newline];
    header = [header,'property float y',newline];
    header = [header,'property float z',newline];
    if(~isempty(N))
        header = [header,'property float nx',newline];
        header = [header,'property float ny',newline];
        header = [header,'property float nz',newline];
    end
    if(~isempty(UV))
        header = [header,'property float u',newline];
        header = [header,'property float v',newline];
    end
    if(~isempty(C))
        header = [header,'property uchar red',newline];
        header = [header,'property uchar green',newline];
        header = [header,'property uchar blue',newline];
    end
end
header = [header,'element face ',num2str(row(F)),newline];
if(~isempty(F))
    header = [header,'property list uchar int vertex_index',newline];
end
header = [header,'end_header',newline];

function writeDataFcn(fileID)
    fprintf(fileID, '%s', header);
    if(~isempty(P))
        fprintf(fileID, [repmat('%f ',1,col(P)),...
                         repmat('%f ',1,col(N)),...
                         repmat('%f ',1,col(UV)),...
                         repmat('%u ',1,col(C)),...
                         newline], [P N UV C]' );
    end
    if(~isempty(F))
        if(iscell(F))
            for i = 1 : row(F)
                fprintf(fileID,['%u', repmat(' %u',1,numel(F{i})),newline], [numel(F{i}) F{i}-1]' );
            end
        else
            fprintf(fileID,['%u', repmat(' %u',1,col(F)),newline], [repmat(col(F),row(F),1) F-1]' );
        end
    end
end
export_to_file(filename,'ply',@writeDataFcn,verbose);
end