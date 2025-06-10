function [P,N,UV,F] = import_OBJ( filename, verbose )
    if(nargin<2)
        verbose = false;
    end
    [P,N,UV,F] = import_from_file(filename,'obj',@readDataFcn,verbose);
end

function [p,n,uv,f] = readDataFcn(fileID)
    func_v  = @(d) strcmp(d(1:2),'v ');
    func_vn = @(d) strcmp(d(1:3),'vn ');
    func_vt = @(d) strcmp(d(1:3),'vt ');
    func_f  = @(d) strcmp(d(1:2),'f ');

    p  = [];
    n  = [];
    uv = [];
    f  = [];
    data = textscan(fileID,'%s','Delimiter',newline);
    data = data{1};

    % search empty lines
    data(cellfun(@(c) isempty(c),data)) = [];
    
    % search comments
    data(cellfun(@(c) strcmp(c(1),'#'),data)) = [];

    % search vertex
    i = find( cellfun(func_v,data) );
    if( ~isempty(i) )
        p = cellfun(@(c) string(strsplit(c)),data(i),'UniformOutput',false);
        p = cellfun(@(c) str2num(str2mat(c(2:4)))',p,'UniformOutput',false);
        p = cell2mat(p);
        data(i) = [];
    end
    
    % search faces
    i = find( cellfun(func_f,data) );
    if( ~isempty(i) )
        txt = strjoin(data(i),'\n');
        f = strsplit(txt,'\n')';
        f = cellfun(@(d) strrep(d,'f ',''),f,'UniformOutput',false);
        f = cellfun(@(d) extract_faces(d),f,'UniformOutput',false);
        if(~any(cellfun(@(x) numel(x)~=numel(f{1}),f)))
            f = cell2mat(f);
        end
        data(i) = [];
    end

    % search normal
    i = find( cellfun(func_vn,data) );
    if( ~isempty(i) )
        n = cellfun(@(c) string(strsplit(c)),data(i),'UniformOutput',false);
        n = cellfun(@(c) str2num(str2mat(c(2:4)))',n,'UniformOutput',false);
        n = cell2mat(n);
        data(i) = [];
    else
        if( ~isempty(f) )
            n = vertex_normal(p,f);
        else
            n = zeros(size(p));
        end
    end
    
    % search texture
    i = find( cellfun(func_vt,data) );
    if( ~isempty(i) )
        uv = cellfun(@(c) string(strsplit(c)),data(i),'UniformOutput',false);
        uv = cellfun(@(c) str2num(str2mat(c(2:3)))',uv,'UniformOutput',false);
        uv = cell2mat(uv);
        data(i) = [];
    else
        uv = zeros(size(p,1),2);
    end
end

function [T] = extract_faces(txt)
    split_space = @(s) strsplit( s, ' ' );
    split_slash = @(s) strsplit( s, '/' );
    extract = @(s) s{1};
    convert = @(s) str2double(s);
    token = erase_empty(split_space(txt));
    T = [];
    for i = 1 : numel(token)
        T = [T,convert(extract(split_slash(token{i})))];
    end
end