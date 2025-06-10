function export_OFF(varargin)
parser = inputParser;
addRequired(  parser, 'filename', @(data) ~isempty(data)&&(ischar(data)||isstring(data)));
addParameter( parser, 'Point',          [], @(data) isnumeric(data));
addParameter( parser, 'Face',           [], @(data) isnumeric(data)||iscell(data));
addParameter( parser, 'Edge',           [], @(data) isnumeric(data));
addParameter( parser, 'computeEdge', false, @(data) islogical(data));
addParameter( parser, 'verbose',     false, @(data) islogical(data));
parse(parser,varargin{:});  
filename = parser.Results.filename;
P = parser.Results.Point;
F = parser.Results.Face;
E = parser.Results.Edge;
e = parser.Results.computeEdge;
verbose = parser.Results.verbose;
if(e&&isempty(E))
    E = poly2edge(F);
end
function writeDataFcn(fileID)
    debug_message('Writing the header...',verbose);
    fprintf(fileID,['%s',newline],'OFF');
    fprintf(fileID,['%u %u %u',newline],[row(P) row(F) row(E)]');
    debug_message(['DONE.',newline],verbose);
    if(~isempty(P))
        debug_message('Writing vertices...',verbose);
        fprintf(fileID,['%f %f %f',newline], P' );
        debug_message(['DONE.',newline],verbose);
    end
    if(~isempty(F))
        debug_message('Writing faces...',verbose);
        if(iscell(F))
            for i = 1 : row(F)
                fprintf(fileID,['%u', repmat(' %u',1,numel(F{i})),newline], [numel(F{i}) F{i}-1]' );
            end
        else
            fprintf(fileID,['%u', repmat(' %u',1,col(F)),newline], [repmat(col(F),row(F),1) F-1]' );
        end
        debug_message(['DONE.',newline],verbose);
    end
    if(~isempty(E))
        debug_message('Writing edges...',verbose);
        fprintf(fileID,['%u %u',newline], E' );
        debug_message(['DONE.',newline],verbose);
    end
    debug_message('Data wrinting completed.',verbose);
end
export_to_file(filename,'off',@writeDataFcn,verbose);
end