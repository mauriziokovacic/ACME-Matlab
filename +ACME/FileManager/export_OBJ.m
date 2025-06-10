function export_OBJ(varargin)
parser = inputParser;
addRequired(  parser, 'filename', @(data) ~isempty(data)&&(ischar(data)||isstring(data)));
addParameter( parser, 'Point',      [], @(data) isnumeric(data));
addParameter( parser, 'Normal',     [], @(data) isnumeric(data));
addParameter( parser, 'UV',         [], @(data) isnumeric(data));
addParameter( parser, 'Face',       [], @(data) isnumeric(data)||iscell(data));
addParameter( parser, 'verbose', false, @(data) islogical(data));
parse(parser,varargin{:});
filename = parser.Results.filename;
P  = parser.Results.Point;
N  = parser.Results.Normal;
UV = full(parser.Results.UV);
if(col(UV)==1)
    UV = [UV zeros(row(UV),1)];
end
F  = parser.Results.Face;
verbose = parser.Results.verbose;
function writeDataFcn(fileID)
    if(~isempty(P))
        fprintf(fileID,['v %f %f %f',newline], P');
    end
    hasN  = ~isempty(N);
    hasUV = ~isempty(UV);
    if(hasN)
        fprintf(fileID,['vn %f %f %f',newline], N');
    end
    if(hasUV)
        fprintf(fileID,['vt %f %f',newline], UV');
    end
    if(~isempty(F))
        t = face_format(hasUV,hasN);
        if(iscell(F))
            for i = 1 : row(F)
                fprintf(fileID,['f',repmat([' ',t],1,numel(F{i})),newline], repelem(F{i},1,1+hasN+hasUV)');
            end
        else
            fprintf(fileID,['f',repmat([' ',t],1,col(F)),newline], repelem(F,1,1+hasN+hasUV)');
        end
    end
end
export_to_file(filename,'obj',@writeDataFcn,verbose);
end

function [s] = face_format(uv,normal)
s = '%u';
if(normal)
    s = [s,'/'];
    if(uv)
        s = [s,'%u'];
    end
    s = [s,'/%u'];
end
end