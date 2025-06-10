function export_CUR( varargin )
parser = inputParser;
addRequired(  parser, 'filename', @(data) ~isempty(data)&&(ischar(data)||isstring(data)));
addParameter( parser, 'Point',             [], @(data) isnumeric(data)||iscell(data));
addParameter( parser, 'Edge',              [], @(data) isnumeric(data)||iscell(data));
addParameter( parser, 'Name',      'Untitled', @(data) ischar(data)||isstring(data)||iscell(data));
addParameter( parser, 'Tangent',           [], @(data) isnumeric(data)||iscell(data));
addParameter( parser, 'Normal',            [], @(data) isnumeric(data)||iscell(data));
addParameter( parser, 'Bitangent',         [], @(data) isnumeric(data)||iscell(data));
addParameter( parser, 'Mesh',              [], @(data) isa(data,'AbstractMesh')||iscell(data));
addParameter( parser, 'Face',              [], @(data) isnumeric(data)||iscell(data));
addParameter( parser, 'Skin',              [], @(data) isa(data,'AbstractSkin')||iscell(data));
addParameter( parser, 'Handle',            [], @(data) isscalar(data)||isnumeric||iscell(data));
addParameter( parser, 'ID',                 0, @(data) isscalar(data)||isnumeric(data)||iscell(data));
addParameter( parser, 'verbose',     false, @(data) islogical(data));
parse(parser,varargin{:});
filename = parser.Results.filename;
P        = parser.Results.Point;
E        = parser.Results.Edge;
Name     = parser.Results.Name;
T        = parser.Results.Tangent;
N        = parser.Results.Normal;
B        = parser.Results.Bitangent;
M        = parser.Results.Mesh;
F        = parser.Results.Face;
S        = parser.Results.Skin;
H        = parser.Results.Handle;
ID       = parser.Results.ID;
verbose  = parser.Results.verbose;

if(strcmpi(Name,''))
    Name = 'Untitled';
end

function writeDataFcn(fileID)
    fprintf(fileID,['%s',newline],Name);
end

export_to_file(filename,'cur',@writeDataFcn,verbose);
end