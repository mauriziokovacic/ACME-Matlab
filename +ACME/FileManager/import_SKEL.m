function [varargout] = import_SKEL( filename )
func_n = @(d) strcmp(d(1:2),'n ');
func_p = @(d) strcmp(d(1:2),'p ');
func_c = @(d) strcmp(d(1:2),'c ');
func_k = @(d) strcmp(d(1:2),'k ');
func_v = @(d) strcmp(d(1:2),'v ');
func_d = @(d) strcmp(d(1:2),'d ');
func_l = @(d) strcmp(d(1:2),'l ');
func_m = @(d) strcmp(d(1:2),'m ');
fileID = fopen(strcat(filename,'.skel'),'r');
data = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);
data = data{1};

if( nargout == 0 )
    return;
end

% search names
if( nargout >= 1 )
    i = find( cellfun(func_n,data) );
    if( ~isempty(i) )
        varargout{1} = cellfun(@(c) string(strsplit(c)),data(i),'UniformOutput',false);
        varargout{1} = cellfun(@(c) char(strjoin(c(2:end),' ')),varargout{1},'UniformOutput',false);
        data(i) = [];
    end
end

% search parent
if( nargout >= 2 )
    i = find( cellfun(func_p,data) );
    if( ~isempty(i) )
        varargout{2} = cellfun(@(c) string(strsplit(c)),data(i),'UniformOutput',false);
        varargout{2} = cellfun(@(c) str2num(str2mat(c(2)))',varargout{2},'UniformOutput',false);
        varargout{2} = cell2mat(varargout{2});
        varargout{2}(varargout{2}==intmax('uint32')) = -1;
        varargout{2} = varargout{2}+1;
        data(i) = [];
    end
end

% search child
if( nargout >= 3 )
    i = find( cellfun(func_c,data) );
    if( ~isempty(i) )
        varargout{3} = cellfun(@(c) string(strsplit(c)),data(i),'UniformOutput',false);
        varargout{3} = cell2mat(cellfun(@(c) str2num(str2mat(c(2:end)))'+1,varargout{3},'UniformOutput',false));
        varargout{3} = sparse(varargout{3}(:,1),varargout{3}(:,2),1,row(varargout{2}),row(varargout{2}));
        data(i) = [];
    end
end

% search level
if( nargout >= 4 )
    i = find( cellfun(func_k,data) );
    if( ~isempty(i) )
        varargout{4} = cellfun(@(c) string(strsplit(c)),data(i),'UniformOutput',false);
        varargout{4} = cell2mat(cellfun(@(c) str2num(str2mat(c(2:end)))'+1,varargout{4},'UniformOutput',false));
        data(i) = [];
    end
end

% search position
if( nargout >= 5 )
    i = find( cellfun(func_v,data) );
    if( ~isempty(i) )
        varargout{5} = cellfun(@(c) string(strsplit(c)),data(i),'UniformOutput',false);
        varargout{5} = cell2mat(cellfun(@(c) str2num(str2mat(c(2:end)))',varargout{5},'UniformOutput',false));
        data(i) = [];
    end
end

% search direction
if( nargout >= 6 )
    i = find( cellfun(func_d,data) );
    if( ~isempty(i) )
        varargout{6} = cellfun(@(c) string(strsplit(c)),data(i),'UniformOutput',false);
        varargout{6} = cell2mat(cellfun(@(c) str2num(str2mat(c(2:end)))',varargout{6},'UniformOutput',false));
        data(i) = [];
    end
end

% search local pose
if( nargout >= 7 )
    i = find( cellfun(func_l,data) );
    if( ~isempty(i) )
        varargout{7} = cellfun(@(c) string(strsplit(c)),data(i),'UniformOutput',false);
        varargout{7} = cell2mat(cellfun(@(c) str2num(str2mat(c(2:end)))',varargout{7},'UniformOutput',false));
        data(i) = [];
    end
end

% search model pose
if( nargout >= 8 )
    i = find( cellfun(func_m,data) );
    if( ~isempty(i) )
        varargout{8} = cellfun(@(c) string(strsplit(c)),data(i),'UniformOutput',false);
        varargout{8} = cell2mat(cellfun(@(c) str2num(str2mat(c(2:end)))',varargout{8},'UniformOutput',false));
        data(i) = [];
    end
end


% formatN = 'n %s\n';
% formatP = 'p %i\n';
% formatC = 'c %u %u\n';
% formatK = 'k %u\n';
% formatV = 'v %f %f %f\n';
% formatD = 'd %f %f %f\n';
% formatL = 'l %f %f %f %f %f %f %f %f %f %f %f %f\n';
% formatM = 'l %f %f %f %f %f %f %f %f %f %f %f %f\n';
% fileID = fopen(strcat(filename,'.skel'),'r');
% if( nargout >= 1 )
%     tmp = textscan( fileID, formatN );
%     varargout{1} = tmp{1};
% end
% if( nargout >= 2 )
%     varargout{2} = fscanf( fileID, formatP, [1 Inf] )' + 1;
% end
% if( nargout >= 3 )
%     T = fscanf( fileID, formatC, [2 Inf] )' + 1;
%     varargout{3} = sparse(T(:,1),T(:,2),1,size(varargout{2},1),size(varargout{2},1));
% end
% if( nargout >= 4 )
%     varargout{4} = fscanf( fileID, formatK, [1 Inf] )' + 1;
% end
% if( nargout >= 5 )
%     varargout{5} = fscanf( fileID, formatV, [3 Inf] )';
% end
% if( nargout >= 6 )
%     varargout{6} = fscanf( fileID, formatD, [3 Inf] )';
% end
% if( nargout >= 7 )
%     varargout{7} = fscanf( fileID, formatL, [12 Inf] )';
% end
% if( nargout >= 8 )
%     varargout{8} = fscanf( fileID, formatM, [12 Inf] )';
% end
% fclose(fileID);
end