function [out] = import_FRG(filename)
[I,D,H] = import_from_file(filename,'frg',@readDataFcn);
out = cell(numel(H),3);
for i = 1 : numel(H)
    out{i,1} = make_column(I{i});
    out{i,2} = D(i);
    out{i,3} = H(i);
end
end

function [I,D,H] = readDataFcn(fileID)
    func_i = @(d) strcmp(d(1:2),'i ');
    func_d = @(d) strcmp(d(1:2),'d ');
    func_h = @(d) strcmp(d(1:2),'h ');

    I  = [];
    D  = [];
    H  = [];
    data = textscan(fileID,'%s','Delimiter',newline);
    data = data{1};

    % search empty lines
    data(cellfun(@(c) isempty(c),data)) = [];
    
    % search comments
    data(cellfun(@(c) strcmp(c(1),'#'),data)) = [];

    % search indices
    i = find( cellfun(func_i,data) );
    if( ~isempty(i) )
        I = cellfun(@(c) string(strsplit(c)),data(i),'UniformOutput',false);
        I = cellfun(@(c) str2num(str2mat(c(2:end)))',I,'UniformOutput',false);
        data(i) = [];
    end
    
    % search distances
    i = find( cellfun(func_d,data) );
    if( ~isempty(i) )
        D = cellfun(@(c) string(strsplit(c)),data(i),'UniformOutput',false);
        D = cell2mat(cellfun(@(c) str2num(str2mat(c(2)))',D,'UniformOutput',false));
        data(i) = [];
    end
    
    % search hierarchy flags
    i = find( cellfun(func_h,data) );
    if( ~isempty(i) )
        H = cellfun(@(c) string(strsplit(c)),data(i),'UniformOutput',false);
        H = logical(cell2mat(cellfun(@(c) str2num(str2mat(c(2)))',H,'UniformOutput',false)));
        data(i) = [];
    end
% 
%     % search normal
%     i = find( cellfun(func_vn,data) );
%     if( ~isempty(i) )
%         n = cellfun(@(c) string(strsplit(c)),data(i),'UniformOutput',false);
%         n = cellfun(@(c) str2num(str2mat(c(2:4)))',n,'UniformOutput',false);
%         n = cell2mat(n);
%         data(i) = [];
%     else
%         if( ~isempty(f) )
%             n = vertex_normal(p,f);
%         else
%             n = zeros(size(p));
%         end
%     end
%     
%     % search texture
%     i = find( cellfun(func_vt,data) );
%     if( ~isempty(i) )
%         uv = cellfun(@(c) string(strsplit(c)),data(i),'UniformOutput',false);
%         uv = cellfun(@(c) str2num(str2mat(c(2:3)))',uv,'UniformOutput',false);
%         uv = cell2mat(uv);
%         data(i) = [];
%     else
%         uv = zeros(size(p,1),2);
%     end
end